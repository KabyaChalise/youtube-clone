import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/channel/users_channel/provider/channel_provider.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';

class UserChannelPage extends StatefulWidget {
  final String userId;
  const UserChannelPage({required this.userId, super.key});

  @override
  State<UserChannelPage> createState() => _UserChannelPageState();
}

class _UserChannelPageState extends State<UserChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return ref.watch(anyUserProvider(widget.userId)).when(
                      data: (data) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset('assets/images/flutter background.png'),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                        data.profilePic),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.displayName,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data.username,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueGrey),
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      '${data.videos} videos '),
                                              TextSpan(
                                                  text:
                                                      '${data.subscriptions.length} subscribers'),
                                            ]))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: FlatButton(
                                  text: 'SUBSCRIBE',
                                  onPressed: () {},
                                  colour: Colors.black),
                            ),
                            data.videos == 0
                                ? const Center(
                                    child: Text('No videos'),
                                  )
                                : Center(
                                    child: Text(
                                        '${data.username} has ${data.videos} videos'),
                                  ),
                          ],
                        );
                      },
                      error: (error, stackTree) => const ErrorPage(),
                      loading: () => const Loader(),
                    );
              },
            ),
            // second consumer for video list
            Consumer(builder: (context, ref, child) {
              return ref.watch(eachChannelVideoProvider(widget.userId)).when(
                    data: (videos) {
                      return Column(
                        children: [
                          videos.isEmpty
                              ? const Center(
                                  child: Text('No videos'),
                                )
                              : Center(
                                  child: Text(
                                      '${videos.length} videos'),
                                ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                color: Colors.grey.shade200,
                                height: 400,
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      // mainAxisSpacing: 10,
                                    ),
                                    itemCount: videos.length,
                                    itemBuilder: (context, index) {
                                      if (videos.isNotEmpty) {
                                        return Post(video: videos[index]);
                                      }
                                      return const SizedBox();
                                    }),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) => const ErrorPage(),
                    loading: () => const Loader(),
                  );
            }),
          ],
        ),
      ),
    );
  }
}
