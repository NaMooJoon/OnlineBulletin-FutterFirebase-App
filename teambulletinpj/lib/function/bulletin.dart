import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/function/addbulletin.dart';
import 'package:shrine/function/viewbulletin.dart';
import 'package:shrine/provider/churchProvider.dart';


class BulletinPage extends StatefulWidget {
  BulletinPage({Key? key}) : super(key: key);

  @override
  _BulletinPageState createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {

  final List list = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChurchProvider>(context, listen: false);
    final Stream<QuerySnapshot> _bulletinStream = FirebaseFirestore.instance.collection('church').doc(provider.church.id).collection('bulletin').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _bulletinStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }
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
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                if (data.isEmpty)
                  return Center(
                    child: TextButton(
                          onPressed: (){},
                          child: Text("주보가 없습니다.")
                    ),
                  );
                return ListTile(
                  leading: Icon(FontAwesomeIcons.paperclip),
                  title: Text(DateFormat('yyyy/MM/dd/').format(DateTime.fromMillisecondsSinceEpoch(data['createAt']))),
                  trailing: Icon(FontAwesomeIcons.bookOpen),
                  onTap: () {
                    if (data['isPDF'] == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => viewBulletinPDF(pdfURL: data['pdfURL'])),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => viewBulletinHTML(html: data['html'])),
                      );
                    }
                  },
                );
              }).toList(),
              // children: <Widget>[
              //   const SizedBox(height: 80.0),
              //   if(list.isEmpty) ... [
              //     TextButton(
              //         onPressed: (){},
              //         child: Text("주보가 없습니다.")
              //     ),
              //   ] else ... [
              //     Text(list[0]),
              //   ],
              //   // bulletins(),
              //   const SizedBox(height: 80.0),
              // ],
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
                  Navigator.of(context).push (
                    MaterialPageRoute(
                      builder: (BuildContext context) => HtmlEditorExample(title: "Bulletin editor"),
                    ),
                  );
                }
              ),
            ],
          ),
        );
      }
    );
  }

  // List<Card> bulletins() {
  //   // CardList를 여기다가 반환해야함.
  // }

  @override
  bool get wantKeepAlive => true;
}


