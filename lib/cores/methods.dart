// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously
import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:youtube_clone/features/upload/long_video/video_details_page.dart';
import 'package:youtube_clone/features/upload/short_video/pages/short_video_screen.dart';

void showErrorSnackBar(String message, context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
// pickvideo is a function that open the gallery and return the video
Future<File?> pickVideo(context) async {
  // opens the gallery
  XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);

  // Check if the file is null
  if (file == null) {
    Fluttertoast.showToast(
      msg: 'No video selected',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
    );
    return null;
  }
  // convert the file to a file object
  File video = File(file.path);
  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailsPage(video: video)));


}
// pickvideo is a function that open the gallery and return the video
Future<File?> pickShortVideo(context) async {
  // opens the gallery
  XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);

  // Check if the file is null
  if (file == null) {
    Fluttertoast.showToast(
      msg: 'No video selected',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
    );
    return null;
  }
  // convert the file to a file object
  File video = File(file.path);
  Navigator.push(context, MaterialPageRoute(builder: (context) => ShortVideoScreen(shortVideo: video)));


}

Future<File?> pickImage() async {
  // Opens the gallery
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

  // Check if the file is null
  if (file == null) {
    Fluttertoast.showToast(
      msg: 'No image selected',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
    );
    return null;
  }

  // Convert the XFile to a File object
  File image = File(file.path);

  // Return the image
  return image;
}

// putFileInStorage is a function that upload the file in the firebase storage
Future<String> putFileInStorage(file, number, fileType) async {
  // create a reference to the file in the firebase storage with the number
  final ref = FirebaseStorage.instance.ref().child('$fileType/$number');
  // upload the file to the firebase storage
  final upload = ref.putFile(file);
  // wait for the upload to finish and get the snapshot
  final snapshot = await upload;
  // get the download url of the file in the firebase storage
  String downloadUrl = await snapshot.ref.getDownloadURL();
  // return the download url for the file
  return downloadUrl;
}
