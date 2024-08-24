import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_editor/video_editor.dart';
import 'package:youtube_clone/cores/methods.dart';
import 'package:youtube_clone/features/upload/short_video/pages/short_video_details.dart';
import 'package:youtube_clone/features/upload/short_video/widgets/trim_slinder.dart';

class ShortVideoScreen extends StatefulWidget {
  final File shortVideo;
  const ShortVideoScreen({super.key, required this.shortVideo});

  @override
  State<ShortVideoScreen> createState() => _ShortVideoScreenState();
}

class _ShortVideoScreenState extends State<ShortVideoScreen> {
  VideoEditorController? editorController;
  final isExporting = ValueNotifier<bool>(false);
  final exportingProgress = ValueNotifier<double>(0.0);
  @override
  void initState() {
    super.initState();
    editorController = VideoEditorController.file(
      widget.shortVideo,
      minDuration: const Duration(seconds: 3),
      maxDuration: const Duration(seconds: 60),
    );
    editorController!.initialize().then((value) => setState(() {}));
  }

  Future<void> exportVideo() async {
    isExporting.value = true;
    // config for ffmpeg which is used to export the video
    final config = VideoFFmpegVideoEditorConfig(editorController!);
    // execute the config to get the command
    final execute = await config.getExecuteConfig();
    // get the command
    final String command = execute.command;
    // export the video
    FFmpegKit.executeAsync(
      command,
      (session) async {
        final ReturnCode? code = await session.getReturnCode();
        if (ReturnCode.isSuccess(code!)) {
          // export the video
          isExporting.value = false;
          Fluttertoast.showToast(
              msg: 'Export Successful',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  ShortVideoDetails(
                    video: widget.shortVideo,
                  )));
        } else {
          // show some error
          showErrorSnackBar('Export Failed', context);
        }
      },
      null,
      (status) {
        exportingProgress.value =
            config.getFFmpegProgress(status.getTime().toInt());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: editorController!.initialized
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              )),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueGrey,
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    AspectRatio(
                        aspectRatio: 4 / 3.6,
                        child: CropGridViewer.preview(
                            controller: editorController!)),
                    const Spacer(),
                    MyTrimSlider(controller: editorController!, height: 45),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, right: 20, left: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                            onPressed: exportVideo, child: const Text('Done')),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
