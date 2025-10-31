import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:friendle/controller/services/AuthServices/auth_services.dart';
import 'package:friendle/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:friendle/utils/text_style.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedCountry = '+91';
  TextEditingController mobileController = TextEditingController();
  bool receiveOTPButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Mobil_no_input_background.png'),
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
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'Let\'s Chat...',
                  style: AppTextStyle.headline2,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  'Enter your Mobile Number',
                  style: AppTextStyle.body1,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode:
                              true, // optional. Shows phone code before the country name.
                          onSelect: (Country country) {
                            log('Select country: ${country.countryCode}');
                            setState(() {
                              selectedCountry = '+${country.phoneCode}';
                            });
                          },
                        );
                      },
                      child: Container(
                        height: 5.h,
                        width: 25.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          selectedCountry,
                          style: AppTextStyle.subBody1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 65.w,
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        cursorColor: black,
                        style: AppTextStyle.body3,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: grey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: grey)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: grey)),
                            hintText: 'Mobile Number',
                            hintStyle:
                                AppTextStyle.body3.copyWith(color: grey)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (mobileController.text.isNotEmpty) {
                      setState(() {
                        receiveOTPButtonPressed = true;
                      });
                      FriendleAuthservices.receiveOTP(
                          context: context,
                          phoneNumber:
                              '$selectedCountry${mobileController.text.trim()}');
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
                          'Get OTP',
                          style: AppTextStyle.body2.copyWith(color: white),
                        ),
                ),
              ],
            )),
      ),
    );
  }
}
