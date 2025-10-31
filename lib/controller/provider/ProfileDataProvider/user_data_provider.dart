import 'package:flutter/material.dart';
import 'package:friendle/controller/services/ProfileServices/profile_services.dart';
import 'package:friendle/model/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? userData;

  fetchUserData() async {
    userData = await ProfileServices.fetchUserData();
    notifyListeners();
  }
}
