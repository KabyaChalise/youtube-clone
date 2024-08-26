// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/content/Long_video/parts/video.dart';

import 'package:youtube_clone/features/upload/long_video/video_model.dart';

class Post extends ConsumerWidget {
  final VideoModel video;
  const Post({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserModel> userModel =
        ref.watch(anyUserProvider(video.userId));
    final user = userModel.whenData((user) => user);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Video(
                      videoModel: video,
                    )));
        FirebaseFirestore.instance
            .collection('videos')
            .doc(video.videoId)
            .update({
          'views': FieldValue.increment(1),
        });
      },
      child: Column(
        children: [
          CachedNetworkImage(
              imageUrl: video.thumbnailUrl,
              height: 250,
              fit: BoxFit.cover,
              width: double.infinity),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      CachedNetworkImageProvider(user.value?.profilePic ?? ''),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                video.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.14),
            child: Row(
              children: [
                Text(
                  user.value?.username ?? '',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    video.views == 0 ? '0 views' : '${video.views} views',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const Text(
                  'a moment ago',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
