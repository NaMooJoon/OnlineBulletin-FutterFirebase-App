import 'package:flutter/material.dart';

class BulletinPage extends StatefulWidget {
  BulletinPage({Key? key}) : super(key: key);

  @override
  _BulletinPageState createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('주보',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 80.0),
            const SizedBox(height: 80.0),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}