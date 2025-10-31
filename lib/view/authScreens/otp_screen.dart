import 'package:flutter/material.dart';
import 'package:friendle/controller/services/AuthServices/auth_services.dart';
import 'package:friendle/utils/colors.dart';
import 'package:friendle/utils/text_style.dart';
import 'dart:async';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  int resendOTPCounter = 60;
  bool receiveOTPButtonPressed = false;

  decreaseCounter() async {
    if (resendOTPCounter > 0) {
      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          resendOTPCounter -= 1;
        });
        decreaseCounter();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      decreaseCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/otp_background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: transparent,
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 2.h,
            ),
            children: [
              SizedBox(height: 5.h),
              Text(
                'Enter the OTP',
                style: AppTextStyle.headline2,
              ),
              SizedBox(
                height: 20.h,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                textStyle: AppTextStyle.body2,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: black,
                    inactiveFillColor: grey300,
                    inactiveColor: grey300,
                    selectedFillColor: white,
                    selectedColor: black,
                    activeFillColor: white),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: transparent,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: otpController,
                onCompleted: (v) {
                  // log("Completed");
                },
                onChanged: (value) {
                  // log(value);
                  // setState(() {
                  //   currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  // log("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              Builder(builder: (context) {
                if (resendOTPCounter > 0) {
                  return RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Resend OTP? ',
                        style: AppTextStyle.subBody2.copyWith(color: grey)),
                    TextSpan(
                        text: '00:$resendOTPCounter',
                        style: AppTextStyle.subBody2.copyWith(color: black))
                  ]));
                } else {
                  return Text('Resend OTP',
                      style: AppTextStyle.subBody2.copyWith(color: black));
                }
              }),
              SizedBox(
                height: 35.h,
              ),
              ElevatedButton(
                onPressed: () {
                  if (otpController.text.isNotEmpty &&
                      receiveOTPButtonPressed == false) {
                    setState(() {
                      receiveOTPButtonPressed = true;
                    });
                    FriendleAuthservices.verifyOTP(
                        context: context, otp: otpController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: Size(90.w, 6.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: receiveOTPButtonPressed
                    ? CircularProgressIndicator(
                        color: white,
                      )
                    : Text(
                        'Verify OTP',
                        style: AppTextStyle.body2.copyWith(color: white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
