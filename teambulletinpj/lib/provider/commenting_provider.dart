import 'package:flutter/cupertino.dart';

class CommentingProvider extends ChangeNotifier{
  bool _isComposing = false ;
  get isComposing => _isComposing;

  void commenting(){
    _isComposing = true;
    notifyListeners();
  }
  void notcommenting(){
    _isComposing = false;
    notifyListeners();
  }
}