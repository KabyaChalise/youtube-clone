import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/content/comment/comment_tile.dart';
import 'package:youtube_clone/features/upload/comments/comments_model.dart';
import 'package:youtube_clone/features/upload/comments/comments_repository.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

class CommentSheet extends ConsumerStatefulWidget {
  final VideoModel video;

  const CommentSheet({super.key, required this.video});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final TextEditingController commentTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).whenData((user) => user);
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Comments",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.close))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: CachedNetworkImageProvider(user.value!.profilePic),
              ),
              SizedBox(
                height: 45,
                width: 260,
                child: TextField(
                  controller: commentTextController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await ref.watch(commentsProvider).uploadCommentToFirestore(
                          videoId: widget.video.videoId,
                          displayName: user.value!.displayName,
                          commentText: commentTextController.text,
                          profilePic: user.value!.profilePic,
                        );
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.green,
                    size: 35,
                  ))
            ],
          ),
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Rememeber to keep comments respectful and follow our community guidelines.'),
              )),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('videoId', isEqualTo: widget.video.videoId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const ErrorPage();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Loader();
                  }
                  final commentsMap = snapshot.data!.docs;
                  final List<CommentsModel> comments = commentsMap
                      .map((comment) => CommentsModel.fromMap(comment.data()))
                      .toList();
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return  CommentTile(
                        comments: comments[index],
                      );
                    },
                  );
                }),
          ),
          // const Spacer(),
          
        ],
      ),
    );
  }
}
