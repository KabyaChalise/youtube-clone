import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/widgets/custom_button.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';
import 'package:youtube_clone/features/search/providers/search_providers.dart';
import 'package:youtube_clone/features/search/widgets/search_channel_tile.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List foundItems = [];
  Future<void> filterList(String searchText) async {
    List<UserModel> users = await ref.watch(allChannelProvider);
    List result = [];
    final foundUsers = users.where((user) {
      return user.displayName.toString().toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    result.addAll(foundUsers);

    final List<VideoModel> videos = await ref.watch(allVideoProvider);
    final foundVideos = videos.where((video) {
      return video.title.toString().toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    result.addAll(foundVideos);
    setState(() {
      result.shuffle();
      foundItems = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  SizedBox(
                    height: 50,
                    width: 270,
                    child: TextFormField(
                      onChanged: (value) async {
                        await filterList(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search Youtube',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 50,
                      width: 60,
                      child: CustomButton(
                          iconData: Icons.search,
                          onTap: () {},
                          haveColor: true))
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foundItems.length,
                  itemBuilder: (context, index) {
                    List<Widget> itemsWidget = [];
                    final selectedItems = foundItems[index];

                    if (selectedItems.runtimeType == VideoModel) {
                      itemsWidget.add(Post(video: selectedItems));
                    }
                    if (selectedItems.runtimeType == UserModel) {
                      itemsWidget.add(SearchChannelTile(
                        user: selectedItems,
                      ));
                    } else if (foundItems.isEmpty) {
                      return const SizedBox();
                    }
                    return itemsWidget[0];
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
