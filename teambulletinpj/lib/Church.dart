import 'package:cloud_firestore/cloud_firestore.dart';

class Church {
  const Church({
    required this.id,
    required this.churchName,
    required this.location,
    required this.imageURL,
    required this.master,
    required this.pastor,
    required this.memberList,
    required this.createdAt,
  });

  final String id;
  final String churchName;
  final String location;
  final String imageURL;
  final String master;
  final String pastor;
  final List<String> memberList;
  final Timestamp createdAt;

  @override
  String toString() => churchName;
}