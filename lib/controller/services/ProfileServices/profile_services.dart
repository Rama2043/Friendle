import 'dart:convert';
import 'dart:developer';

import 'package:friendle/constants/constant.dart';
import 'package:friendle/model/user_model.dart';

class ProfileServices {
  static fetchUserData() async {
    try {
      final snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.uid}')
          .get();
      if (snapshot.exists) {
        UserModel userData = UserModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        return userData;
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
