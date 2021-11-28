import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shrine/function/addbulletin.dart';
import 'package:shrine/provider/churchProvider.dart';


import 'addbulletin.dart';

class BulletinPage extends StatefulWidget {
  BulletinPage({Key? key}) : super(key: key);

  @override
  _BulletinPageState createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {

  final List list = [];
  Future<void> getBulletin() async {
    final provider = Provider.of<ChurchProvider>(context, listen: false);
    FirebaseFirestore.instance
        .collection('church')
        .doc(provider.church.id)
        .collection('bulletin')
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((document) {
        list.add(document);
      });
    });
  }

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
            TextButton(
              onPressed: (){
                Navigator.of(context).push (
                  MaterialPageRoute(
                    builder: (BuildContext context) => HtmlEditorExample(title: "Bulletin editor"),
                  ),
                );
              },
              child: Text("주보가 없습니다.")
            ),
            // bulletins(),
            const SizedBox(height: 80.0),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        buttonSize: 45,
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            label: "Camera",
            onTap: () async {
              Navigator.of(context).push (
                MaterialPageRoute(
                  builder: (BuildContext context) => CapturedBulletin(),
                ),
              );
            }
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.pen),
            label: "Writing",
            onTap: () {
              /*Navigator.of(context).push (
                MaterialPageRoute(
                  builder: (BuildContext context) => HtmlEditorExample(title: "Bulletin editor"),
                ),
              );*/
            }
          ),
        ],
      ),
    );
  }

  // Widget bulletins() {
  //   var htmlData = '<p><img src="https://mblogthumb-phinf.pstatic.net/20160616_243/yn1984_1466081798536CjTlr_JPEG/2.jpg?type=w2" style="width: 390.286px;" data-filename="Google network image"></p><h2>Handong</h2>';
  //   return Html(
  //       data: htmlData,
  //   );
  // }
}

