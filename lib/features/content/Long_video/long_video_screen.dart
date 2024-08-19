import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

class LongVideoScreen extends StatelessWidget {
  const LongVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('videos').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const ErrorPage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            // getting all the videos from the database
            final videoMaps = snapshot.data!.docs;
            // mapping the videos to the video model
            final video = videoMaps.map((video) {
              // used from map to convert the map to the video model
              return VideoModel.fromMap(video.data());
              // converting to list to use in the listview builder
            }).toList();
            return ListView.builder(
                itemCount: video.length,
                itemBuilder: (context, index) {
                  return Post(
                    video: video[index],
                  );
                });
          }),
    );
  }
}
