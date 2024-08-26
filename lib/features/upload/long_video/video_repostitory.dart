// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

final longVideoProvider =
    Provider((ref) => VideoRepository(firestore: FirebaseFirestore.instance));

class VideoRepository {
  FirebaseFirestore firestore;
  VideoRepository({
    required this.firestore,
  });

  uploadVideoToFirestore(
      {required String videoUrl,
      required String thumbnailUrl,
      required String title,
      required DateTime datePublished,
      required int views,
      required String videoId,
      required String userId,
      required List likes,
      required String types}) async {
    VideoModel video = VideoModel(
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      title: title,
      datePublished: datePublished,
      views: 0,
      videoId: videoId,
      userId: userId,
      likes: [],
      types: 'video',
    );
    await firestore.collection('videos').doc(videoId).set(video.toMap());
  }

  Future<void> likedVideo({
   required List? likes,
   required videoId,
   required currentUserId,
  }) async {
    if (!likes!.contains(currentUserId)) {
      await FirebaseFirestore.instance.collection('videos').doc(videoId).update({
        'likes': FieldValue.arrayUnion([currentUserId]),
      });
    }
    if (likes.contains(currentUserId)) {
      await FirebaseFirestore.instance.collection('videos').doc(videoId).update({
        'likes': FieldValue.arrayRemove([currentUserId]),
      });
    }
  }
}
