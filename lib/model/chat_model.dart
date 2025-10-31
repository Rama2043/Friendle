// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  String message;
  DateTime messageSendTime;
  String userName;
  String profilePicUrl;
  String userId;

  ChatModel({
    required this.message,
    required this.messageSendTime,
    required this.userName,
    required this.profilePicUrl,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'messageSendTime': messageSendTime.millisecondsSinceEpoch,
      'userName': userName,
      'profilePicUrl': profilePicUrl,
      'userId': userId,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'] as String,
      messageSendTime:
          DateTime.fromMillisecondsSinceEpoch(map['messageSendTime'] as int),
      userName: map['userName'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
