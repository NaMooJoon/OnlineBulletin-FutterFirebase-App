import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shrine/function/storystruct.dart';
import 'package:shrine/provider/churchProvider.dart';
import 'package:shrine/provider/login_provider.dart';


class editPage extends StatefulWidget{
  final Story post;
  const editPage({Key? key, required this.post}) : super(key: key);

  @override
  State<editPage> createState() => _editPageState();
}

class _editPageState extends State<editPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: <Widget>[
              TextButton(
                child: Text("upload"),
                style: TextButton.styleFrom(
                    primary: Colors.black,
                    padding: EdgeInsets.fromLTRB(20, 5, 10, 5)
                  //textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                    _updateFile(context).whenComplete(() => Navigator.pop(context));
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              '게시글 수정',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          body: Column(
            children: [
              if (widget.post.contentimgUrl != "") ...[
                Column(
                  children: [
                    Container(
                      width: 500,
                      height: 300,
                      child: Center(
                          child: Image.network(widget.post.contentimgUrl)
                      ),
                    )
                  ],
                ),
              ] else ...[
                const SizedBox.shrink(),
              ],
              LayoutBuilder(
                  builder: (context, constraints){
                    return Center(
                      child: Padding(
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: '내용'
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _nameController..text = widget.post.content,
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                    );
                  })
            ],
          )
      ),
    );
  }
  Future _updateFile(BuildContext context) async{
    final churchprovider = Provider.of<ChurchProvider>(context, listen:false);
    final loginprovider = Provider.of<LoginProvider>(context, listen: false);
    try{
      await FirebaseFirestore.instance.collection('church').doc(churchprovider.church.id).collection('infostory').doc(widget.post.docid).set({
        'content':_nameController.text,
      },SetOptions(merge: true));
    }catch(e){
      print(e);
    }
  }
}
