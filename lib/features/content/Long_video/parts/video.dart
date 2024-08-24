// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/cores/colors.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';
import 'package:youtube_clone/features/content/Long_video/widgets/video_externel_buttons.dart';
import 'package:youtube_clone/features/content/comment/comment_sheet.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

// ignore: must_be_immutable
class Video extends ConsumerStatefulWidget {
  VideoModel? videoModel;

  Video({Key? key, required this.videoModel}) : super(key: key);

  @override
  ConsumerState<Video> createState() => _VideoState();
}

class _VideoState extends ConsumerState<Video> {
  bool isShowIcon = false;
  bool isPlaying = false;
  VideoPlayerController? _controller;
  @override
  initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
      widget.videoModel!.videoUrl,
    ))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  toggleVideoPlay() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      isPlaying = false;
      setState(() {});
    } else {
      _controller!.play();
      isPlaying = true;
      setState(() {});
    }
  }

  backVideoPlay() {
    Duration position = _controller!.value.position;
    position = position - Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  forwardVideoPlay() {
    Duration position = _controller!.value.position;
    position = position + Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserModel> user =
        ref.watch(anyUserProvider(widget.videoModel!.userId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(176),
          child: _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    onTap: isShowIcon
                        ? () {
                            setState(() {
                              isShowIcon = false;
                            });
                          }
                        : () {
                            setState(() {
                              isShowIcon = true;
                            });
                          },
                    child: Stack(
                      children: [
                        VideoPlayer(
                          _controller!,
                        ),
                        isShowIcon
                            ? Positioned(
                                left: 30,
                                top: 82,
                                child: GestureDetector(
                                  onTap: () {
                                    backVideoPlay();
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/go_back_final.png',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        isShowIcon
                            ? Positioned(
                                right: 30,
                                top: 82,
                                child: GestureDetector(
                                  onTap: () {
                                    forwardVideoPlay();
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/go ahead final.png',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Center(child: SizedBox()),
                        isShowIcon
                            ? Positioned(
                                left: 170,
                                top: 82,
                                child: GestureDetector(
                                  onTap: () {
                                    toggleVideoPlay();
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    child: isPlaying
                                        ? Image.asset(
                                            'assets/images/pause.png',
                                            color: Colors.white,
                                          )
                                        : Image.asset(
                                            'assets/images/play.png',
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Positioned(
                              height: 7.5,
                              child: VideoProgressIndicator(_controller!,
                                  colors: VideoProgressColors(
                                    playedColor: Colors.red,
                                    bufferedColor: Colors.grey,
                                    backgroundColor: Colors.white,
                                  ),
                                  allowScrubbing: true)),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: const Loader()),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                widget.videoModel!.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      widget.videoModel!.views == 0
                          ? 'No views'
                          : '${widget.videoModel!.views} views',
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: Text(
                      "5 minutes ago",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 9,
                right: 9,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(user.value!.profilePic),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 5,
                    ),
                    child: Text(
                      user.value!.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 6,
                    ),
                    child: Text(
                      user.value!.subscriptions.isEmpty
                          ? 'No Subscription'
                          : user.value!.subscriptions.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FlatButton(
                        text: "Subscribe",
                        onPressed: () {},
                        colour: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9, top: 10.5, right: 9),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: const BoxDecoration(
                        color: softBlueGreyBackGround,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.thumb_up,
                              size: 15.5,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.thumb_down,
                            size: 15.5,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Share",
                        iconData: Icons.share,
                      ),
                    ),
                    const VideoExtraButton(
                      text: "Remix",
                      iconData: Icons.analytics_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Download",
                        iconData: Icons.download,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // comment box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context, builder: (context) => CommentSheet(
                    video: widget.videoModel!,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  height: 45,
                  width: 200,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('videos')
                    .where('videoId', isNotEqualTo: widget.videoModel!.videoId)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return ErrorPage();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Loader();
                  }
                  final videoMap = snapshot.data!.docs;
                  final videos = videoMap
                      .map((video) => VideoModel.fromMap(video.data()))
                      .toList();
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          return Post(video: videos[index]);
                        }),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
