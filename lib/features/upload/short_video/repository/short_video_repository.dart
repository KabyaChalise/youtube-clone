import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/upload/short_video/model/short_video_model.dart';

final shortVideoProvider = Provider((ref) => ShortVideoRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class ShortVideoRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ShortVideoRepository({required this.auth, required this.firestore});

  Future<void> addShortVideo({
    required String caption,
    required String video,
    required DateTime datePublished,
  }) async {
    ShortVideoModel shortVideo = ShortVideoModel(
        caption: caption,
        userId: auth.currentUser!.uid,
        shortVideo: video,
        datePublished: datePublished);
    // here we are using add instead of set and doc as we want the id to be auto generated randomly
    await firestore.collection('shorts').add(shortVideo.toMap());
  }
}
