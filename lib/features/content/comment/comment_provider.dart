import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/upload/comments/comments_model.dart';

final commentsProvider =
    FutureProvider.family.autoDispose((ref, videoId) async {
  final commentsMap = await FirebaseFirestore.instance
      .collection('comments')
      .where('videoId', isEqualTo: videoId)
      .get();
  final List<CommentsModel> comments = commentsMap.docs.map((comment) => CommentsModel.fromMap(comment.data())).toList();
  return comments;
});
