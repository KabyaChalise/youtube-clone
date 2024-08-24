import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/upload/short_video/repository/short_video_repository.dart';

class ShortVideoDetails extends ConsumerStatefulWidget {
  final File video;
  const ShortVideoDetails({super.key, required this.video});

  @override
  ConsumerState<ShortVideoDetails> createState() => _ShortVideoDetailsState();
}

class _ShortVideoDetailsState extends ConsumerState<ShortVideoDetails> {
  final captionController = TextEditingController();
  final DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'Short Video Details',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: FlatButton(
                  text: 'Publish',
                  onPressed: () async {
                    await ref.watch(shortVideoProvider).addShortVideo(
                          caption: captionController.text,
                          video: widget.video.path,
                          datePublished: date,
                        );
                  },
                  colour: Colors.green,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
