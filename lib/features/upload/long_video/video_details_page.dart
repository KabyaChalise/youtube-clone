import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_clone/cores/methods.dart';
import 'package:youtube_clone/features/upload/long_video/video_repostitory.dart';

class VideoDetailsPage extends ConsumerStatefulWidget {
  final File? video;
  const VideoDetailsPage(  {super.key, this.video});

  @override
  ConsumerState<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends ConsumerState<VideoDetailsPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isThumbnailSelected = false;
  String randomNumber = const Uuid().v4();
  String videoId = const Uuid().v4();
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the title',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter video title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Enter the description',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: 'Enter video description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // select thumbnail
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: () async {
                    // pick image
                    image = await pickImage();
                    isThumbnailSelected = true;
                    setState(() {});
                  },
                  child: const Text(
                    'Select Thumbnail',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              isThumbnailSelected
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Image.file(
                        image!,
                        cacheHeight: 300,
                        cacheWidth: 400,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              // select thumbnail
              isThumbnailSelected
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () async{
                          // publish video
                          String thumbnail =
                             await putFileInStorage(image, randomNumber, 'image');
                          String videoUrl = await putFileInStorage(widget.video, randomNumber, 'video');
                          
                          ref.watch(longVideoProvider).uploadVideoToFirestore(
                                videoUrl: videoUrl,
                                thumbnailUrl: thumbnail,
                                title: titleController.text,
                                datePublished: DateTime.now(),
                                views: 0,
                                videoId: videoId,
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                likes: [],
                                types: 'video',
                              );
                        },
                        child: const Text(
                          'Publish',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      )),
    );
  }
}
