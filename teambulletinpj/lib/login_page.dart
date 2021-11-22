import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shrine/provider/login_provider.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            OutlinedButton.icon(
                onPressed: () {
                  final state = Provider.of<LoginProvider>(context, listen: false);
                  state.signInWithGoogle().whenComplete(() =>  Navigator.pushReplacementNamed(context, '/search'));
                },
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.blue),
                label: Text('Google SignIn')),
            OutlinedButton.icon(
                onPressed: () {
                  final state = Provider.of<LoginProvider>(context, listen: false);
                  state.signOut();
                  //signInWithGoogle().whenComplete(() => Navigator.pushReplacementNamed(context, '/home'));
                },
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.blue),
                label: Text('Logout')),
          ],
        ),
      ),
    );
  }

}