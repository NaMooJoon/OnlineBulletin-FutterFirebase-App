import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoDetailPage extends StatefulWidget {
  final String documentId;
  const InfoDetailPage({Key? key, required this.documentId}) : super(key: key);

  @override
  State<InfoDetailPage> createState() => _InfoDetailPageState();
}

class _InfoDetailPageState extends State<InfoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("infotest")
            .doc(widget.documentId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                leading: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Back"),
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  '교회 소식',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              body: ListView(
                children: [
                  const SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    child: Image.network(
                      data['imgURL'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        data['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    child: Row(
                      children: [
                          Flexible(
                            child: Text(
                              data['Content'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
