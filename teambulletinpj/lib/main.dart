import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/provider/churchProvider.dart';
import 'package:shrine/provider/commenting_provider.dart';
import 'package:shrine/provider/like_provider.dart';
import 'package:shrine/provider/login_provider.dart';
import 'package:shrine/route.dart';

void main() => runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (context) => ProFileProvider()),
        //ChangeNotifierProvider(create: (context) => DropDownProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => LikeProvider()),
        ChangeNotifierProvider(create: (context) => ChurchProvider()),
        ChangeNotifierProvider(create: (context) => CommentingProvider()),
      ],
      child: App(),
    ));

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
            return BulletinApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}