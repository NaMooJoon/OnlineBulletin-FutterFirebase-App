import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/function/editinfo.dart';
import 'package:shrine/provider/churchProvider.dart';

class InfoDetailPage extends StatefulWidget {
  final String documentId;
  const InfoDetailPage({Key? key, required this.documentId}) : super(key: key);

  @override
  State<InfoDetailPage> createState() => _InfoDetailPageState();
}

class _InfoDetailPageState extends State<InfoDetailPage> {
  @override
  Widget build(BuildContext context) {
    final churchprovider = Provider.of<ChurchProvider>(context, listen:false);
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('church').doc(churchprovider.church.id)
            .collection("infotest")
            .doc(widget.documentId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz),
                    onSelected: (String result) {
                      setState(() {
                        if(result == "삭제"){
                          FirebaseFirestore.instance.collection('church').doc(churchprovider.church.id).collection('infotest').doc(widget.documentId).delete().whenComplete(() => Navigator.pop(context));
                        }
                        if(result == "수정"){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => editinfoPage(docid: widget.documentId,
                            content: data['content'], title: data['title'], imgUrl: data['contentimgUrl'],)));
                        }
                      });
                    },
                    itemBuilder: (BuildContext context) => <String>["삭제","수정"]
                        .map((value) => PopupMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                        .toList(),
                  ),
                ],
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
                  if (data['contentimgUrl'] != "") ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.network(data['contentimgUrl']),
                    )
                  ] else ...[
                    const SizedBox.shrink(),
                  ],
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
                              data['content'],
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
          return Center(child: CircularProgressIndicator());
        });
  }
}
