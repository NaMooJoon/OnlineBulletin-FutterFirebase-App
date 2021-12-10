import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'provider/login_provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  TextEditingController _churchNameController = TextEditingController();
  TextEditingController _callNumberController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _pastorController = TextEditingController();

  String defaultURL = 'https://mblogthumb-phinf.pstatic.net/20160616_243/yn1984_1466081798536CjTlr_JPEG/2.jpg?type=w2';
  File? _image;
  bool _imagePicked = false;
  String? _url;

  Future<void> registerChurch() {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    DocumentReference ref = _database.collection("church").doc();
    provider.updateChurchData(ref.id, false);
    return ref.set({
      'churchId' : ref.id,
      'createdAt' : FieldValue.serverTimestamp(),
      'churchName': _churchNameController.text,
      'location': _locationController.text,
      'callNumber': _callNumberController.text,
      'imageURL': _imagePicked ? _url : defaultURL,
      'master': provider.user.uid,
      'pastor': _pastorController.text,
      'memberList': [provider.user.uid],
    });
  }

  Future imagePickerMethod() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if(image!=null) {
        _image = File(image.path);
        _imagePicked = true;
      }
    });
    uploadImage();
  }

  Future uploadImage() async {
    String postID = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    Reference ref = FirebaseStorage.instance.ref().child(postID);
    await ref.putFile(_image!);
    String url = await ref.getDownloadURL();
    setState(() {
      if(url!='') {
        _url = url;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '교회 등록하기',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              if ( _churchNameController.text != '' &&
                   _callNumberController.text != '' &&
                   _locationController.text != ''   &&
                   _pastorController.text != '' ) {
                await registerChurch();
                Navigator.of(context).pushNamed('/home');
              }
            },
            child: Text(
              '완료',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),
            ),
            textColor: Colors.green,
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10.0),
          Image.network(
            'https://mblogthumb-phinf.pstatic.net/20160616_243/yn1984_1466081798536CjTlr_JPEG/2.jpg?type=w2',
            width: 420,
            height: 200,
            fit: BoxFit.fill,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    semanticLabel: 'camera',
                  ),
                  onPressed: imagePickerMethod,
                ),]
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: [
                TextFormField(
                    controller: _churchNameController,
                    decoration: InputDecoration(
                      hintText: '교회 이름',
                    )
                ),
                TextFormField(
                    controller: _callNumberController,
                    decoration: InputDecoration(
                      hintText: '전화번호',
                    )
                ),
                TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: '위치',
                    )
                ),
                TextFormField(
                    controller: _pastorController,
                    decoration: InputDecoration(
                      hintText: '담임목사',
                    )
                ),
              ],
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}