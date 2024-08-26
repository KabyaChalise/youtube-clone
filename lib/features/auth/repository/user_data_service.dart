// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';

// userDataServiceProvider is a provider that return UserDataService
final userDataServiceProvider = Provider(
  (ref) => UserDataService(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

// class UserDataService is a class that return addUserDataToFirestore method
class UserDataService {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  UserDataService({
    required this.auth,
    required this.firestore,
  });
// addUserDataToFirestore is a method that adds user data to Firestore
  addUserDataToFirestore({
    String? userId,
    required String displayName,
    required String username,
    required String email,
    required String profilePic,
    String? subsciption,
    int? videos, // Make videos an optional parameter
    required String description,
    String? type,
  }) async {
    // Fetch the user's existing data
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(userId ?? auth.currentUser!.uid)
        .get();

    // Use the existing video count if available, otherwise default to 0
    int currentVideoCount = userDoc.exists ? userDoc['videos'] ?? 0 : 0;

    // If videos is provided, add it to the current count; otherwise, use the current count
    int updatedVideoCount = currentVideoCount + (videos ?? 0);

    // Create the user model with the updated video count
    UserModel user = UserModel(
      userId: userId ?? auth.currentUser!.uid,
      displayName: displayName,
      username: username,
      email: email,
      profilePic: profilePic,
      subscriptions:
          userDoc.exists ? List<String>.from(userDoc['subscriptions']) : [],
      videos: updatedVideoCount, // Use the calculated video count
      description: description,
      type: type ?? 'user',
    );

    // Add the user to Firestore
    await firestore
        .collection('users')
        .doc(userId ?? auth.currentUser!.uid)
        .set(
            user.toMap(),
            SetOptions(
                merge: true)); // Use merge to avoid overwriting existing data
  }

  Future<UserModel> fetchCurrentUserData() async {
    final currentUserMap =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }

  Future<UserModel> fetchAnyUserData(userId) async {
    final currentUserMap =
        await firestore.collection('users').doc(userId).get();
    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }
}
