import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:songpick/auth.dart';
import './second/friendsonglist.dart';

class SecondApp extends StatefulWidget {
  const SecondApp({Key? key}) : super(key: key);

  @override
  State<SecondApp> createState() => _SecondApp();
}

class _SecondApp extends State<SecondApp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final currentUser = FirebaseAuth.instance;

  Future<void> _send() async {
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
                    controller: emailController,
                    decoration: InputDecoration(labelText: '이메일'),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String email = emailController.text;
                        final String name = nameController.text;
                        /*await FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUser.currentUser!.email.toString())
                            .collection(
                                currentUser.currentUser!.email.toString())
                            .add({
                          "friend": email,
                          "name": name,
                          "isfriend": false,
                        });*/
                        await FirebaseFirestore.instance.collection('request')
                            .doc(email)
                            .collection(email).doc(currentUser.currentUser!.email.toString())
                            .set({
                          "mail" : currentUser.currentUser!.email.toString()
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('친구요청 전송')),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _edit(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'];
    emailController.text = documentSnapshot['friend'];

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
                    controller: emailController,
                    decoration: InputDecoration(labelText: '이메일'),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '이름'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String email = emailController.text;
                        final String name = nameController.text;
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUser.currentUser!.email.toString())
                            .collection(
                                currentUser.currentUser!.email.toString()).doc(documentSnapshot.id)
                            .update({"friend": email, "name": name, "isfriend":true});
                        Navigator.of(context).pop();
                      },
                      child: Text('수정하기')),
                ],
              ),
            ),
          );
        });
  }

  //DocumentReference documentReference = FirebaseFirestore.instance.collection('user').

  /*Future<String> get_data(DocumentReference documentReference) async {
    DocumentSnapshot documentSnapshot = await documentReference
        .get();
    var document_id = documentSnapshot.reference.id;
    return document_id;
  }*/

  var card_width = List.generate(20, (index) => 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구들의 노래방'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.currentUser!.email.toString())
            .collection(currentUser.currentUser!.email.toString())
            .where("isfriend", isEqualTo: true)
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
                    title: Text(documentSnapshot['friend']),
                    subtitle: Text(documentSnapshot['name']),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "수정",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                _edit(documentSnapshot);
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      ),
                    ),onTap: (){
                      print(documentSnapshot['friend']);
                      String arg = documentSnapshot['friend'];
                    //Navigator.pushNamed(context, '/second/friendsonglist', arguments: documentSnapshot.id);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FriendSLApp(id: arg)));
                  },
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
          _send();
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
