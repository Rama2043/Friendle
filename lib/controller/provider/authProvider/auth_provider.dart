import 'package:flutter/material.dart';

class FriendleAuthProvider extends ChangeNotifier {
  String verificationID = '';

  updateVerificationID(String id) {
    verificationID = id;
    notifyListeners();
  }
}
