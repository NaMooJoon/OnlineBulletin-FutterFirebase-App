import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  const Story({
    required this.username,
    required this.contentimgUrl,
    required this.userimgUrl,
    required this.updatetime,
    required this.content,
    required this.docid,
    required this.uid,
    required this.likeUsers,
    required this.likeUserList,
    //required this.url,
    //required this.name,
    //required this.price,
    //required this.description,
    //required this.like,
    //required this.userList,
    //required this.created,
    //required this.updated,
  });
  final String username;
  final String contentimgUrl;
  final String updatetime;
  final String content;
  final String userimgUrl;
  final String docid;
  final String uid;
  final int likeUsers;
  final List<dynamic> likeUserList;
  //final String url;
  //final String name;
  //final int price;
  //final String description;
  //final int like;
  //final List<String> userList;
  //final Timestamp created;
  //final Timestamp updated;

  @override
  String toString() => username;
}