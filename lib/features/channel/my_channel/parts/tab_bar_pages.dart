import 'package:flutter/material.dart';

class TabBarPages extends StatelessWidget {
  const TabBarPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: TabBarView(children: [
        Center(child: Text('Home')),
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
