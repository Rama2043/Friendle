import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendle/constants/constant.dart';
import 'package:friendle/controller/provider/authProvider/auth_provider.dart';
import 'package:friendle/model/user_model.dart';
import 'package:friendle/view/ChatScreens/chat_screen.dart';
import 'package:friendle/view/authScreens/login_screen.dart';
import 'package:friendle/view/authScreens/otp_screen.dart';
import 'package:friendle/view/authScreens/registration_screen.dart';
import 'package:friendle/view/authScreens/signin_logic_screen.dart';
import 'package:provider/provider.dart';

class FriendleAuthservices {
  static receiveOTP(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            log(credential.toString());
          },
          verificationFailed: (FirebaseAuthException exception) {
            log(exception.toString());
            throw Exception(exception);
          },
          codeSent: (String verificationId, int? resendToken) {
            Provider.of<FriendleAuthProvider>(context, listen: false)
                .updateVerificationID(verificationId);
            log(verificationId);

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OTPScreen()));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId:
              Provider.of<FriendleAuthProvider>(context, listen: false)
                  .verificationID,
          smsCode: otp);
      await auth.signInWithCredential(credential);
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SigninLogicScreen()),
          (route) => false);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static registerUsersData(
      {required UserModel userData, required BuildContext context}) {
    realTimeDatabaseRef
        .child('User/${auth.currentUser!.uid}')
        .set(userData.toMap())
        .then((value) {
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return SigninLogicScreen();
      }), (route) => false);
    }).onError((error, stackTrace) {});
  }

  static checkAuthentication() {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static isUserRegistered() async {
    try {
      final snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.uid}')
          .get();
      if (snapshot.exists) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static checkAuthNRegistration(BuildContext context) async {
    if (checkAuthentication()) {
      bool userRegistered = await isUserRegistered();
      if (userRegistered) {
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
            (route) => false);
      } else {
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }
}
