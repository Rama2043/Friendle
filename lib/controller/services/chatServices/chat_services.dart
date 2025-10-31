import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:friendle/constants/constant.dart';
import 'package:friendle/controller/provider/ProfileDataProvider/user_data_provider.dart';
import 'package:friendle/model/chat_model.dart';
import 'package:friendle/model/user_model.dart';
import 'package:provider/provider.dart';

class ChatServices {
  static uploadMessageToDatabase(String message, BuildContext context) {
    String messageID = DateTime.now().millisecondsSinceEpoch.toString();
    UserModel userData =
        Provider.of<UserDataProvider>(context, listen: false).userData!;
    log(messageID);
    ChatModel chatData = ChatModel(
        message: message,
        messageSendTime: DateTime.now(),
        userName: userData.name,
        profilePicUrl: userData.profilePic,
        userId: auth.currentUser!.uid);
    realTimeDatabaseRef.child('Chats/$messageID').set(chatData.toMap());
  }
}
