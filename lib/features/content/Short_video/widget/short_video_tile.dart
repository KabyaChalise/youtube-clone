import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/features/content/Long_video/parts/video.dart';
import 'package:youtube_clone/features/upload/short_video/model/short_video_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShortVideoTile extends StatefulWidget {
  final ShortVideoModel shortVideo;
  const ShortVideoTile({super.key, required this.shortVideo});

  @override
  State<ShortVideoTile> createState() => _ShortVideoTileState();
}

class _ShortVideoTileState extends State<ShortVideoTile> {
  VideoPlayerController? shortVideoController;
  @override
  void initState() {
    super.initState();
    shortVideoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.shortVideo.shortVideo))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          shortVideoController!.value.isInitialized
              ? Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!shortVideoController!.value.isPlaying) {
                          shortVideoController!.play();
                        } else {
                          shortVideoController!.pause();
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: 11 / 16,
                        child: VideoPlayer(shortVideoController!),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.shortVideo.caption,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Text(timeago.format(widget.shortVideo.datePublished),
                            style: const TextStyle(fontSize: 20)),
                      ],
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
