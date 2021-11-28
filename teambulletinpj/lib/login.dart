import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'provider/login_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '로그인',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 60,),
            Container(
              width: 350.0,
              height: 50,
              child: FlatButton.icon(
                onPressed: () {
                  final provider = Provider.of<LoginProvider>(context, listen: false);
                  provider.signInWithGoogle().then((User user){
                    Navigator.of(context).pushNamed('/home');
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side : BorderSide(color: Colors.black),
                ),
                icon: FaIcon(FontAwesomeIcons.google),
                label: Text("구글 로그인", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,), ),
              ),
            ),
            SizedBox(height: 12,),
            Container(
              width: 350.0,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  final provider = Provider.of<LoginProvider>(context, listen: false);
                  provider.signOut();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side : BorderSide(color: Colors.black),
                ),
                child: Text("(임시) 로그인 하기 전에 로그아웃", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,), ),
              ),
            ),
            SizedBox(height: 60,),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}