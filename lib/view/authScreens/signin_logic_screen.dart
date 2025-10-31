import 'package:flutter/material.dart';
import 'package:friendle/controller/services/AuthServices/auth_services.dart';
import 'package:sizer/sizer.dart';

class SigninLogicScreen extends StatefulWidget {
  const SigninLogicScreen({super.key});

  @override
  State<SigninLogicScreen> createState() => _SigninLogicScreenState();
}

class _SigninLogicScreenState extends State<SigninLogicScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FriendleAuthservices.checkAuthNRegistration(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: const Image(
          image: AssetImage('assets/images/splash_Screen.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
