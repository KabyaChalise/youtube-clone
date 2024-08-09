// ignore_for_file: public_member_api_docs, sort_constructors_first
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
// addUserDataToFirestore is a method that add user data to firestore
  addUserDataToFirestore({
    String? userId,
    required String displayName,
    required String username,
    required String email,
    required String profilePic,
    String? subsciption,
    int? videos,
    required String description,
    String? type,
  }) async {
    // create user model with all data
    UserModel user = UserModel(
      // acess all data from the auth
      userId: auth.currentUser!.uid,
      displayName: displayName,
      username: username,
      email: email,
      profilePic: profilePic,
      subscriptions: [],
      videos: 0,
      description: description,
      type: 'user',
    );
    // add the user to the firestore
    await firestore
        // new collection user and if already exists add to it
        .collection('users')
        // doc will get the current user id from the auth
        .doc(auth.currentUser!.uid)
        // set all data inside the user model to map to add all the data in firebase database
        .set(user.toMap());
  }

  Future<UserModel> fetchCurrentUserData() async {
    final currentUserMap = await firestore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }
}
