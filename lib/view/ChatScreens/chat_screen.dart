import 'dart:convert';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:friendle/constants/constant.dart';
import 'package:friendle/controller/provider/ProfileDataProvider/user_data_provider.dart';
import 'package:friendle/controller/services/chatServices/chat_services.dart';
import 'package:friendle/model/chat_model.dart';
import 'package:friendle/utils/colors.dart';
import 'package:friendle/utils/text_style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserDataProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friendle',
          style: AppTextStyle.headline2,
        ),
        centerTitle: true,
        backgroundColor: white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: realTimeDatabaseRef.child('Chats').onValue,
                  builder: (context, event) {
                    if (event.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: teal400,
                        ),
                      );
                    }
                    if (event.data == null) {
                      return Center(
                          child: Text(
                        'Please Start Chatting',
                        style: AppTextStyle.body2,
                      ));
                    }
                    if (event.data != null) {
                      return FirebaseAnimatedList(
                          query: realTimeDatabaseRef.child('Chats'),
                          itemBuilder: (context, snapshot, animation, index) {
                            ChatModel chat = ChatModel.fromMap(
                                jsonDecode(jsonEncode(snapshot.value))
                                    as Map<String, dynamic>);
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 1.h),
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.teal[100],
                                    ),
                                    child: Text(
                                      chat.message,
                                      style: AppTextStyle.body3
                                          .copyWith(color: white),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: teal400,
                      ),
                    );
                  })),
          Container(
            constraints: BoxConstraints(minHeight: 6.h, minWidth: 100.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: teal400),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: chatController,
                  cursorColor: white,
                  keyboardType: TextInputType.multiline,
                  style: AppTextStyle.body2.copyWith(color: white),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5.w),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Message',
                      hintStyle:
                          AppTextStyle.body3.copyWith(color: Colors.white70)),
                )),
                IconButton(
                    onPressed: () {
                      if (chatController.text.trim().isNotEmpty) {
                        ChatServices.uploadMessageToDatabase(
                            chatController.text.trim(), context);
                        chatController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Cannot send an empty message',
                          style: AppTextStyle.subBody1,
                        )));
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      size: 25,
                      color: white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
