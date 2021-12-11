import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/provider/churchProvider.dart';

class InformationEditPage extends StatefulWidget {
  InformationEditPage({Key? key}) : super(key: key);

  @override
  _InformationEditPageState createState() => _InformationEditPageState();
}

class _InformationEditPageState extends State<InformationEditPage> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  File? _image;
  bool _imagePicked = false;
  String? _url;

  Future<void> modifyChurchData(String cid, String name, String location, String callNumber, String pastor) {
    DocumentReference ref = _database.collection("church").doc(cid);
    return ref.update({
      'churchName': name,
      'location': location,
      'callNumber': callNumber,
      'pastor': pastor,
      'imageURL': _url,
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
    final churchState = Provider.of<ChurchProvider>(context, listen: false);
    _url = churchState.church.imageURL;

    TextEditingController _churchNameController = TextEditingController(text:churchState.church.churchName);
    TextEditingController _callNumberController = TextEditingController(text:churchState.church.callNumber);
    TextEditingController _locationController = TextEditingController(text:churchState.church.location);
    TextEditingController _pastorController = TextEditingController(text:churchState.church.pastor);

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
              await modifyChurchData(
                churchState.church.id,
                _churchNameController.text,
                _callNumberController.text,
                _locationController.text,
                _pastorController.text,
              );
              Navigator.of(context).pushNamed('/home');
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
            _url!,
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
                ),
                TextFormField(
                    controller: _callNumberController,
                ),
                TextFormField(
                    controller: _locationController,
                ),
                TextFormField(
                    controller: _pastorController,
                ),
              ],
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}