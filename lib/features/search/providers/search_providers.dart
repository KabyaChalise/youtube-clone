import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

final allChannelProvider = Provider((ref) async {
  //getting all channels from firestore
  final usersMap = await FirebaseFirestore.instance.collection('users').get();
  //mapping the data to the model and converting it to a list
  List<UserModel> users = usersMap.docs
      .map(
        (user) => UserModel.fromMap(
          user.data(),
        ),
      )
      .toList();
  return users;
});
final allVideoProvider = Provider((ref) async {
  //getting all channels from firestore
  final videosMap = await FirebaseFirestore.instance.collection('videos').get();
  //mapping the data to the model and converting it to a list
  List<VideoModel> videos = videosMap.docs
      .map(
        (video) => VideoModel.fromMap(
          video.data(),
        ),
      )
      .toList();
  return videos;
});
