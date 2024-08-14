// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final DateTime datePublished;
  final int views;
  final String videoId;
  final String userId;
  final List likes;
  final String types;

  VideoModel(
      {required this.videoUrl,
      required this.thumbnailUrl,
      required this.title,
      required this.datePublished,
      required this.views,
      required this.videoId,
      required this.userId,
      required this.likes,
      required this.types});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'datePublished': datePublished,
      'views': views,
      'videoId': videoId,
      'userId': userId,
      'likes': likes,
      'types': types,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      videoUrl: map['videoUrl'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      title: map['title'] as String,
      datePublished: (map['datePublished'] as Timestamp).toDate(),
      views: map['views'] as int,
      videoId: map['videoId'] as String,
      userId: map['userId'] as String,
      likes: List.from(
        (map['likes'] as List),
      ),
      types: map['types'] as String,
    );
  }
}
