import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/function/addbulletin.dart';
import 'package:shrine/function/viewbulletin.dart';
import 'package:shrine/provider/churchProvider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


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
    CollectionReference bulletin = FirebaseFirestore.instance.collection('church').doc(provider.church.id).collection('bulletin');
    final Stream<QuerySnapshot> _bulletinStream = bulletin.snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _bulletinStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
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
                print(data.length);
                if (!document.exists) {
                  return Center(
                    child: TextButton(
                        onPressed: (){},
                        child: Text("주보가 없습니다.")
                    ),
                  );
                }
                return Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),
                  // The end action pane is the one at the right or the bottom sie.
                  endActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: doNothing,
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                      SlidableAction(
                        onPressed: (context) => {
                          bulletin
                              .doc(document.id)
                              .delete()
                              .then((value) => print("User deleted"))
                              .catchError((error) => print("Failed to delete user: $error")),
                          setState((){}),
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.

                  child: ListTile(
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
                  ),
                );
              }).toList(),
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
                  ).then((_) => setState(() {}));
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
                  ).then((_) => setState(() {}));
                }
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void doNothing(BuildContext context)  {
  print("doNothing function called!");
}

