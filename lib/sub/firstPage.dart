import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:songpick/auth.dart';
import 'package:flutter/material.dart';

class FirstApp extends StatefulWidget {
  const FirstApp({Key? key}) : super(key: key);

  @override
  State<FirstApp> createState() => _FirstApp();
}

class _FirstApp extends State<FirstApp> {
  User? user = Auth().currentUser;

  final TextEditingController countController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController singerController = TextEditingController();

  Future<void> _RaiseCount(DocumentSnapshot documentSnapshot) async {
    var count = documentSnapshot['count'];

    var plus = count + 1;
    FirebaseFirestore.instance
        .collection(currentUser.currentUser!.email.toString())
        .doc(documentSnapshot.id)
        .update({"count": plus});
  }

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'];
    genreController.text = documentSnapshot['genre'];
    singerController.text = documentSnapshot['singer'];

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '곡명'),
                  ),
                  TextField(
                    controller: genreController,
                    decoration: InputDecoration(labelText: '장르'),
                  ),
                  TextField(
                    controller: singerController,
                    decoration: InputDecoration(labelText: '가수'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = nameController.text;
                        final String genre = genreController.text;
                        final String singer = singerController.text;
                        FirebaseFirestore.instance
                            .collection(
                                currentUser.currentUser!.email.toString())
                            .doc(documentSnapshot.id)
                            .update({
                          "name": name,
                          "genre": genre,
                          "singer": singer
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('수정')),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '곡명'),
                  ),
                  TextField(
                    controller: genreController,
                    decoration: InputDecoration(labelText: '장르'),
                  ),
                  TextField(
                    controller: singerController,
                    decoration: InputDecoration(labelText: '가수'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = nameController.text;
                        final String genre = genreController.text;
                        final String singer = singerController.text;

                        await FirebaseFirestore.instance
                            .collection(
                                currentUser.currentUser!.email.toString())
                            .add({
                          "name": name,
                          "genre": genre,
                          "singer": singer,
                          "count": 0
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('등록')),
                ],
              ),
            ),
          );
        });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나만의 노래방'),
      ),
      body: StreamBuilder(
        //stream: product.snapshots(),
        //stream: FirebaseFirestore.instance.collection('user').where("email",isEqualTo: currentUser.currentUser!.email).snapshots(),
        //stream: FirebaseFirestore.instance.collection('songlist').doc().collection(currentUser.currentUser!.email.toString()).snapshots(),
        stream: FirebaseFirestore.instance
            .collection(currentUser.currentUser!.email.toString())
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['singer']),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            documentSnapshot['genre'].toString(),
                            style: TextStyle(
                                color: Colors.deepPurpleAccent, fontSize: 20),
                          ),
                          Text(
                            documentSnapshot['count'].toString(),
                            style:
                                TextStyle(color: Colors.purple, fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              _RaiseCount(documentSnapshot);
                            },
                            icon: Icon(Icons.add),
                          ),
                          IconButton(
                              onPressed: () {
                                _update(documentSnapshot);
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          _create();
        },
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
      //StreamBuilder로 지속적인 데이터 주고 받음
    );
  }
}
