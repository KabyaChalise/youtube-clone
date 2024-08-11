import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/colors.dart';

class TabBarPage extends StatelessWidget {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        labelColor: Colors.black,
        dividerColor: softBlueGreyBackGround,
        indicatorColor: Colors.black,
        isScrollable: true,
        labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.only(top: 10),
        tabs: [
          Tab(text: 'Home'),
          Tab(text: 'Videos'),
          Tab(text: 'Shots'),
          Tab(text: 'Comedy'),
          Tab(text: 'Playlists'),
          Tab(text: 'Channels'),
          Tab(text: 'About'),
        ],
      ),
    );
  }
}
