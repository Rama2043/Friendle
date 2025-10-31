import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:friendle/constants/constant.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices {
  static getImageFromGallery({required BuildContext context}) async {
    File selectedImage;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    XFile? filePick = pickedFile;

    if (filePick != null) {
      selectedImage = File(filePick.path);
      log('$selectedImage');
      return File(selectedImage.path);
    } else {
      return;
    }
  }

  static uploadImageToFirebaseStorage(
      {required File image, required BuildContext context}) async {
    String userID = auth.currentUser!.phoneNumber!;

    String imageName = userID;
    Reference ref =
        firebaseStorage.ref().child('Profile_Images').child(imageName);
    await ref.putFile(File(image.path));
    String imageUrl = await ref.getDownloadURL();
    log('Uploaded Image to Firebase');
    return imageUrl;
  }
}
