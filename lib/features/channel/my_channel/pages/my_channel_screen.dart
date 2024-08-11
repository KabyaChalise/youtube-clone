import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:youtube_clone/cores/colors.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/cores/widgets/image_button.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/channel/my_channel/parts/buttons.dart';
import 'package:youtube_clone/features/channel/my_channel/parts/tab_bar.dart';
import 'package:youtube_clone/features/channel/my_channel/parts/tab_bar_pages.dart';
import 'package:youtube_clone/features/channel/my_channel/parts/top_header.dart';

class MyChannelScreen extends ConsumerWidget {
  const MyChannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when(
          data: (user) {
            return DefaultTabController(
                length: 7,
                child: Scaffold(
                  body: SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        // top header
                        TopHeader(user: user),
                        const Text(
                          'More about Kabya Chalise',
                        ),
                        // create buttons
                        const Buttons(),
                        // create tab bar
                        const TabBarPage(),
                        // tab bar pages
                        const TabBarPages(),
                      ],
                    ),
                  )),
                ));
          },
          error: (error, stackTrace) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}
