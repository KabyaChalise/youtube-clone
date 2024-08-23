import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_clone/features/upload/comments/comments_model.dart';

final commentsProvider = Provider(
    (ref) => CommentsRepository(firestore: FirebaseFirestore.instance));

class CommentsRepository {
  final FirebaseFirestore firestore;

  CommentsRepository({required this.firestore});

  Future<void> uploadCommentToFirestore({
    required String videoId,
    required String displayName,
    required String commentText,
    required String profilePic,
  }) async {
    String commentId = Uuid().v4();

    CommentsModel comment = CommentsModel(
      commentId: commentId,
      videoId: videoId,
      displayName: displayName,
      commentText: commentText,
      profilePic: profilePic,
    );
    await firestore.collection('comments').doc(commentId).set(comment.toMap());
  }
}
