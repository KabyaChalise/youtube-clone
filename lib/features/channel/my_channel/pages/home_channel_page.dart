import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/channel/users_channel/provider/channel_provider.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';

class HomeChannelPage extends StatelessWidget {
  const HomeChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return ref
            .watch(eachChannelVideoProvider(
                FirebaseAuth.instance.currentUser!.uid))
            .when(
              data: (videos) {
                return Column(
                  children: [
                    videos.isEmpty
                        ? const Center(
                            child: Text('No videos'),
                          )
                        : Center(
                            child: Text('${videos.length} videos'),
                          ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: videos.isEmpty
                            ? const Center(
                                child: Text(
                                'No videos',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ))
                            : Container(
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
    );
  }
}
