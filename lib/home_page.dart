import 'package:firebase_auth/firebase_auth.dart';
import 'package:songpick/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title(){
    return Text('구글 파이어베이스 로그인');
  }
  Widget _userid()
  {
    return Text(user?.email ?? 'User email');
  }
  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text('로그아웃'));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userid(),
            _signOutButton()
          ],
        ),
      ),
    );
  }
}