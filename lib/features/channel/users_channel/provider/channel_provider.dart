import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

final eachChannelVideoProvider = FutureProvider.family(
  (ref, userId) async {
    final videoMap = await FirebaseFirestore.instance
        .collection('videos')
        .where('userId', isEqualTo: userId)
        .get();
    final videos =  videoMap.docs;
    final List<VideoModel> videoModels = videos.map((video) => VideoModel.fromMap(video.data())).toList();
    return videoModels;
  },
);
