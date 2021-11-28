import 'package:flutter/material.dart';
import '../Church.dart';

class ChurchProvider extends ChangeNotifier {
  late Church _church;
  Church get church => _church;

  void setChurchData(Church ch) {
    _church = ch;
    notifyListeners();
  }
}