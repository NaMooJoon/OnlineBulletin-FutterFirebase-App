import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shrine/function/storystruct.dart';

import 'infostories.dart';

class StoryPage extends StatefulWidget {
  StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
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
  }
}