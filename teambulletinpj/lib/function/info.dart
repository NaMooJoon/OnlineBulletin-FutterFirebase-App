import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shrine/function/storystruct.dart';

import 'infodetail.dart';
import 'infostories.dart';

class InfoPage extends StatefulWidget {
  InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<Story> story = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('infostory').get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        story = snapshot.data!.docs.map<Story>((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Story(
                username: data['name'],
                contentimgUrl: data['contentimgUrl'],
                updatetime: data['updatetime'],
                content: data['content'],
                userimgUrl: data['userimgUrl'],
                likeUsers: data['likeUsers'].length,
                likeUserList: data['likeUsers'],
                docid: document.id,
                uid: data['uid'],
            );
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final Story post = story[index];
                    return PostContainer(post: post);
                  },
                  childCount: story.length,
                ),
              )
            ],
          );
      },
    );
      /*ListView(
        children: [
          const SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(color: Colors.grey),
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Column(
              children: [
                Text("교회 기본 이미지"),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.all(35),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "전화번호",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Divider(color: Colors.grey, thickness: 0.5),
                Row(
                  children: [
                    Text(
                      "위치",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Divider(color: Colors.grey, thickness: 0.5),
                Row(
                  children: [
                    Text(
                      "담임목사: ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 35.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "교회소식",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey, thickness: 0.5),
                Column(
                  children: [
                    CardList(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class CardList extends StatefulWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('infotest').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return GridView.count(
            //physics: ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 1,
            childAspectRatio: 8 / 2,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                clipBehavior: Clip.antiAlias,
                // TODO: Adjust card heights (103)
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoDetailPage(
                            documentId : document.id,
                          ),
                        ));
                  },
                  child: Row(
                    // TODO: Center items on the card (103)
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(data['imgURL'] as String,fit: BoxFit.fitWidth),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                          child: Column(
                            // TODO: Align labels to the bottom and center (103)
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // TODO: Change innermost Column (103)
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    data['title'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height:5),
                              Row(
                                children: [
                                  Text(
                                    data['Content'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height:3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data['updatetime'],
                                    style: TextStyle(
                                      fontSize: 6,
                                    ),
                                  )
                                ],
                              )
                              /*Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: const Text('more',
                                          style: TextStyle(color: Colors.black)),
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.all(0)),
                                      onPressed: () {
                                        //Navigator.pushNamed(context, '/detail');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                documentId : document.id,
                                              ),
                                            ));
                                        /*(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          img: product.assetName, name: product.name, star: product.star, location: product.location, description: product.description,phone:product.phone
                                      ),
                                    ));*/
                                      },
                                    ),
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        });
  }
}
