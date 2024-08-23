import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_clone/features/upload/comments/comments_model.dart';

class CommentTile extends StatelessWidget {
  final CommentsModel comments;
  const CommentTile({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 17,
                backgroundImage:
                    CachedNetworkImageProvider(comments.profilePic),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comments.displayName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 10),
                    const Text("2 days ago"),
                  ],
                ),
                Text(
                  comments.commentText,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const Spacer(),
            const Icon(Icons.more_vert, color: Colors.black),
          ],
        )
       
        );
  }
}
