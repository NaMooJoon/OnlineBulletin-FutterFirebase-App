import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LikeProvider extends ChangeNotifier{
  late int count;
  late bool _isliked;
  bool get isliked => _isliked;
  final docref = FirebaseFirestore.instance.collection('church');
  void setLiked(){
    _isliked = true;
    notifyListeners();
  }
  void setdisLiked(){
    _isliked = false;
    notifyListeners();
  }

  void addLike(String uid, String cid, String docid){
    docref.doc(cid).collection('infostory').doc(docid).update({
      'likeUsers': FieldValue.arrayUnion([uid])
    });
    notifyListeners();
    //docref.where("likeUsers",isEqualTo: userid ).get().then((QuerySnapshot docs) async {}
  }

  void deleteLike(String uid, String cid, String docid){
    docref.doc(cid).collection('infostory').doc(docid).update({
      'likeUsers': FieldValue.arrayRemove([uid])
    });
    notifyListeners();
    //docref.where("likeUsers",isEqualTo: userid ).get().then((QuerySnapshot docs) async {}
  }

  void isLiked(String uid, String docid){ //안씀
    FirebaseFirestore.instance
        .collection('infostory')
        .doc(docid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        count = data['likeUsers'].length;
        if(data['likeUsers'].contains(uid)){
          _isliked = true;
        }
        else{
          _isliked = false;
        }
        ;
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}