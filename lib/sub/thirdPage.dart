import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:songpick/auth.dart';

class ThirdApp extends StatefulWidget {
  const ThirdApp({Key? key}) : super(key: key);

  @override
  State<ThirdApp> createState() => _ThirdApp();
}

class _ThirdApp extends State<ThirdApp> {

  User? user = Auth().currentUser;

  final TextEditingController friendController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final currentUser = FirebaseAuth.instance;

  var click = List.generate(20, (index) => true);
  var msg = List.generate(20, (index) => "친구 요청 수락");

  late DocumentReference _documentReference;

  Future<void> _delete1(String productId,int index) async {

    return showDialog(
        context: context,
        barrierDismissible: false,//다이얼 로그 이 외 바탕을 눌러도 안꺼지게 설정
        builder: (BuildContext context) {
        return AlertDialog(
          title: Text('친구등록을 하시겠습니까?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

              ],
            )
          ),
          actions: [
            TextButton(onPressed: (){
              FirebaseFirestore.instance.collection('user')
                  .doc(productId).collection(
                  productId)
                  .add(
                  {
                    "friend": currentUser.currentUser!.email
                        .toString(),
                    "name": '',
                    "isfriend": true
                  }
              );
              FirebaseFirestore.instance.collection('request').doc(
                  currentUser.currentUser!.email.toString()).collection(
                  currentUser.currentUser!.email.toString()).doc(productId).delete();

              Navigator.of(context).pop();
              }, child: Text('예')),
            TextButton(onPressed: (){
              setState(() {
                click[index] = true;
                msg[index] = '친구 요청 수락';
              });
              Navigator.of(context).pop();
            }, child: Text('아니오')),
          ],
        );
    });
  }
  Future<void> _delete2(String productId) async {

    return showDialog(
        context: context,
        barrierDismissible: false,//다이얼 로그 이 외 바탕을 눌러도 안꺼지게 설정
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('친구요청을 삭제 하시겠습니까?'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[

                  ],
                )
            ),
            actions: [
              TextButton(onPressed: (){
                FirebaseFirestore.instance.collection('request').doc(
                    currentUser.currentUser!.email.toString()).collection(
                    currentUser.currentUser!.email.toString()).doc(productId).delete();
                Navigator.of(context).pop();
              }, child: Text('예')),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('아니오')),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구요청 처리 페이지(최대 20개)'),
      ),
      body: StreamBuilder(
        //stream: product.snapshots(),
        //stream: FirebaseFirestore.instance.collection('user').where("email",isEqualTo: currentUser.currentUser!.email).snapshots(),
        //stream: FirebaseFirestore.instance.collection('songlist').doc().collection(currentUser.currentUser!.email.toString()).snapshots(),
        stream: FirebaseFirestore.instance
            .collection('request')
            .doc(currentUser.currentUser!.email.toString())
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
                    title: Text(documentSnapshot['mail']),
                    //subtitle: Text(documentSnapshot['singer']),
                    trailing: SizedBox(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            msg[index],
                            style:
                            TextStyle(color: Colors.purple, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  click[index] = false;
                                  msg[index] = '친구요청 수락됨';
                                });

                                _delete1(documentSnapshot.id,index);
                              },
                              icon: Icon((click[index] == false)
                                  ? Icons.check
                                  : Icons.circle)),
                          IconButton( //삭제 구현 필요
                            onPressed: () {
                              setState(() {});
                              _delete2(documentSnapshot.id);
                            },
                            icon: Icon(Icons.delete),
                          )
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

    );
  }
}
