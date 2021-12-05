import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  const Comments({
    required this.username,
    required this.content,
    required this.userimgUrl,
    required this.updatetime,
    required this.uid,
    required this.docid,
    required this.commentid,

    //required this.contentimgUrl,
    //required this.docid,
    //required this.uid,
    //required this.likeUsers,
    //required this.likeUserList,
    //required this.comment_content,
    //required this.comment_userid,
    //required this.comment_username,
    //required this.comment_userimgUrl,
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
  final String updatetime;
  final String content;
  final String userimgUrl;
  final String uid;
  final String docid;
  final String commentid;
  //final String contentimgUrl;
  //final String docid;
  //final String uid;
  //final int likeUsers;
  //final List<dynamic> likeUserList;
  //final String comment_content;
  //final String comment_userid;
  //final String comment_username;
  //final String
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