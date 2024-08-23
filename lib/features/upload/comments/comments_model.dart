// ignore_for_file: public_member_api_docs, sort_constructors_first

class CommentsModel {
  final String commentId;
  final String videoId;
  final String displayName;
  final String commentText;
  final String profilePic;

  CommentsModel({
    required this.commentId,
    required this.videoId,
    required this.displayName,
    required this.commentText,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'videoId': videoId,
      'displayName': displayName,
      'commentText': commentText,
      'profilePic': profilePic,
    };
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      commentId: map['commentId'] as String,
      videoId: map['videoId'] as String,
      displayName: map['displayName'] as String,
      commentText: map['commentText'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

}
