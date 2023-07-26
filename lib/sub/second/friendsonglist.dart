import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendSLApp extends StatefulWidget{
  final String id;
  const FriendSLApp({Key? key, required this.id}) :super(key: key);

  @override
  State<FriendSLApp> createState() => _FriendSLApp();
}

class _FriendSLApp extends State<FriendSLApp>{
  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String guest = widget.id;
    return Scaffold(
      appBar: AppBar(
        title: Text('$guest들의 노래방'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(guest)
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
                        ],
                      ),
                    )
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      //StreamBuilder로 지속적인 데이터 주고 받음
    );
  }
}