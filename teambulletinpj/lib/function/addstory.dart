import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shrine/provider/login_provider.dart';


class addPage extends StatefulWidget{
  const addPage({Key? key}) : super(key: key);

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
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
                if(_image == null){
                  _uploadFileNoImg(context).whenComplete(() => Navigator.pop(context));
                }
                else{
                  _uploadFile(context).whenComplete(() => Navigator.pop(context));
                }
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '게시글 등록',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                _image == null ? SizedBox.shrink()
                    :
                Container(
                  width: 500,
                  height: 300,
                  child: Center(
                      child: Image.file(File(_image!.path), width:400, fit: BoxFit.cover)
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: (){
                    getImageFromGallery();
                  },
                  icon: Icon(Icons.camera_enhance),
                )
              ],
            ),
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
                        controller: _nameController,
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

  Future getImageFromGallery() async{
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    //var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState((){
      _image = image!;
    });
  }
  Future _uploadFile(BuildContext context) async{
    List<String> likeusers =[];
    List<String> comments =[];
    final loginprovider = Provider.of<LoginProvider>(context, listen: false);
    try{
      final firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
      final upload = firebaseStorageRef.putFile(File(_image!.path));
      await upload.whenComplete(() => null);

      final downUrl = await firebaseStorageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('infostory').add({
        'name' : loginprovider.user.displayName,
        'uid' : loginprovider.user.uid,
        'updatetime': FieldValue.serverTimestamp(),
        'userimgUrl': loginprovider.user.photoURL,
        'content':_nameController.text,
        'contentimgUrl': downUrl,
        'likeUsers': FieldValue.arrayUnion(likeusers),
        'coments':FieldValue.arrayUnion(comments),

        /*'name' : _nameController.text,
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'image': downUrl,
        'userid':FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'lastmodified': FieldValue.serverTimestamp(),
        'like': 0,*/
      });
    }catch(e){
      print(e);
    }
  }
  Future _uploadFileNoImg(BuildContext context) async{
    List<String> likeusers =[];
    List<String> comments =[];
    final loginprovider = Provider.of<LoginProvider>(context, listen: false);
    try{
      await FirebaseFirestore.instance.collection('infostory').add({
        'name' : loginprovider.user.displayName,
        'uid' : loginprovider.user.uid,
        'updatetime': FieldValue.serverTimestamp(),
        'userimgUrl': loginprovider.user.photoURL,
        'content':_nameController.text,
        'contentimgUrl': "",
        'likeUsers': FieldValue.arrayUnion(likeusers),
        'coments':FieldValue.arrayUnion(comments),

        /*'name' : _nameController.text,
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'image': downUrl,
        'userid':FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'lastmodified': FieldValue.serverTimestamp(),
        'like': 0,*/
      });
    }catch(e){
      print(e);
    }
  }
}
