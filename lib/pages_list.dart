import 'package:flutter/material.dart';
import 'package:youtube_clone/features/content/Long_video/long_video_screen.dart';

List pages = [
  LongVideoScreen(),
  const Center(child: Text('Shorts')),
  const Center(child: Text('Uploads')),
  const Center(child: Text('Search')),
  const Center(child: Text('Log out')),
];
