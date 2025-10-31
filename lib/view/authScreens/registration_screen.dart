import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendle/constants/constant.dart';
import 'package:friendle/controller/services/AuthServices/auth_services.dart';
import 'package:friendle/controller/services/ImageServices/image_services.dart';
import 'package:friendle/model/user_model.dart';
import 'package:friendle/utils/colors.dart';
import 'package:friendle/utils/text_style.dart';
import 'package:sizer/sizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  File? profilePic;
  getProfilePicFromGallery() async {
    final image = await ImageServices.getImageFromGallery(context: context);
    if (image != null) {
      setState(() {
        profilePic = File(image.path);
      });
    }
  }

  fetchNUpdateMobileNumber() {
    String phoneNumber = auth.currentUser!.phoneNumber ?? '';
    setState(() {
      phoneNumberController.text = phoneNumber;
    });
  }

  bool isRegistrationButtonPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchNUpdateMobileNumber();
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
      child: Scaffold(
        backgroundColor: transparent,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          children: [
            SizedBox(
              height: 5.h,
            ),
            InkWell(
              onTap: getProfilePicFromGallery,
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: grey100,
                  image: profilePic != null
                      ? DecorationImage(
                          image: FileImage(profilePic!), fit: BoxFit.contain)
                      : null,
                ),
              ),
            ),
            // Builder(builder: (context) {
            //   if (profilePic != null) {
            //     return CircleAvatar(
            //       radius: 7.h,
            //       backgroundImage: FileImage(profilePic!),
            //     );
            //   } else {
            //     return InkWell(
            //       onTap: getProfilePicFromGallery,
            //       child: CircleAvatar(
            //         radius: 7.h,
            //       ),
            //     );
            //   }
            // }),
            SizedBox(
              height: 8.h,
            ),
            RegistrationDataInputWidget(
              controller: nameController,
              title: 'Name',
              keyboardType: TextInputType.name,
            ),
            RegistrationDataInputWidget(
              controller: userNameController,
              title: 'Username',
              keyboardType: TextInputType.name,
            ),
            RegistrationDataInputWidget(
              controller: phoneNumberController,
              title: 'Mobile Number',
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            SizedBox(
              height: 10.h,
            ),
            ElevatedButton(
              onPressed: () async {
                if ((profilePic != null) &&
                    (nameController.text.isNotEmpty) &&
                    (userNameController.text.isNotEmpty) &&
                    (phoneNumberController.text.isNotEmpty)) {
                  setState(() {
                    isRegistrationButtonPressed = true;
                  });
                  String profilePicUrl =
                      await ImageServices.uploadImageToFirebaseStorage(
                          image: profilePic!, context: context);
                  UserModel userData = UserModel(
                      name: nameController.text.trim(),
                      userName: userNameController.text.trim(),
                      phoneNumber: phoneNumberController.text.trim(),
                      profilePic: profilePicUrl);
                  if (!context.mounted) return;
                  await FriendleAuthservices.registerUsersData(
                      userData: userData, context: context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: Size(90.w, 6.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: isRegistrationButtonPressed
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Register',
                      style: AppTextStyle.body2.copyWith(color: white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationDataInputWidget extends StatelessWidget {
  const RegistrationDataInputWidget(
      {super.key,
      required this.controller,
      required this.title,
      required this.keyboardType,
      this.readOnly = false});

  final TextEditingController controller;
  final String title;
  final TextInputType keyboardType;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.body2.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.h,
        ),
        TextField(
          controller: controller,
          cursorColor: black,
          style: AppTextStyle.body3,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 0),
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
              hintText: title,
              hintStyle: AppTextStyle.body3.copyWith(color: grey)),
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
