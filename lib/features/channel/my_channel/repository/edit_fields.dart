// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final editSettingsProvider = Provider(
  (ref) => EditFields(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class EditFields {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  EditFields({
    required this.firestore,
    required this.auth,
  });

  editDisplayName(String displayName) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'displayName': displayName,
    });
  }

  editUserName(String username) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'username': username,
    });
  }

  editDiscription(String description) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'description': description,
    });
  }

  // editProfilePic(XFile profilePic) async {
  //   await firestore.collection('users').doc(auth.currentUser!.uid).update({
  //     'profilePic': profilePic.path,
  //   });
  // }

}
