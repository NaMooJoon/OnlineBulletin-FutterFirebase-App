import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget{
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('infostory').orderBy('updatetime',descending: true).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/addstory');
                    },
                    icon: Icon(Icons.add)
                )
              ],
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                '댓글',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            body: Center(
              
            ),
          );
        }
        return Text("loading");
      },
    );
  }
}