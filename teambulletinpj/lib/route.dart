import 'package:flutter/material.dart';
import 'package:shrine/function/addinfo.dart';

import 'function/addstory.dart';
import 'function/comment.dart';
import 'function/editstory.dart';
import 'function/storystruct.dart';
import 'home.dart';
import 'login.dart';
import 'register.dart';
import 'search.dart';

class BulletinApp extends StatelessWidget {
  const BulletinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shrine',
        home: LoginPage(),
        initialRoute: '/login',
        routes:{
          '/home':(context)=> LoginPage(),
          '/register': (context) => RegisterPage(),
          '/search': (context) => SearchPage(),
          '/home' : (context) => HomePage(),
          '/addstory':(context) => addPage(),
          '/addinfo':(context) => addinfoPage(),
          '/comment':(context) => CommentPage(docid:"", userimg: '', content: '', username: '',),
          '/editstory':(context) => editPage(post: Story(likeUserList: [], content: '', updatetime: '', uid: '', contentimgUrl: '', likeUsers: 0, docid: '', username: '', userimgUrl: '')),

        }
    );
  }
}
