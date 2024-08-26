import 'package:flutter/material.dart';
import 'package:youtube_clone/features/channel/my_channel/pages/home_channel_page.dart';

class TabBarPages extends StatelessWidget {
  const TabBarPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: TabBarView(children: [
        HomeChannelPage(),
        Center(child: Text('Videos')),
        Center(child: Text('Shots')),
        Center(child: Text('Comedy')),
        Center(child: Text('Playlists')),
        Center(child: Text('Channels')),
        Center(child: Text('About')),
      ]),
    );
  }
}
