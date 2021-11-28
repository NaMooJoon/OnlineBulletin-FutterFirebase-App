import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  bool _isLoggedInWithGoogle = false;
  bool get isLoggedInWithGoogle => _isLoggedInWithGoogle;

  late User _user;
  User get user => _user;

  List<String> _churchList = [];
  List<String> get churchList => _churchList;

  Future<User> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =
    await googleSignInAccount!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);

    User? user = _auth.currentUser;

    _isLoggedInWithGoogle = true;
    _user = user!;

    DocumentSnapshot data = await _database.collection("user").doc(user.uid).get();
    if(data.exists) {
      _churchList = data['churchList']?.cast<String>();
    } else {
      updateGoogleUserData(user);
    }

    notifyListeners();

    return user;
  }

  void updateGoogleUserData(User user) {
    _database.collection('user').doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
      'uid': user.uid,
      'churchList' : [],
    });
  }

  void signOut() async {
    if (_isLoggedInWithGoogle) {
      await _googleSignIn.signOut();
      _isLoggedInWithGoogle = false;
      notifyListeners();
    }
  }

  void updateChurchData(String churchId) {
    _churchList.add(churchId);
    _database.collection('user').doc(user.uid).update({
      'churchList' : _churchList,
    });
    notifyListeners();
  }
}