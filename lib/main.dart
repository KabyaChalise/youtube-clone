// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_clone/cores/firebase_options.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/auth/pages/login_page.dart';
import 'package:youtube_clone/features/auth/pages/username_page.dart';
import 'package:youtube_clone/features/channel/my_channel/pages/channel_settings.dart';
import 'package:youtube_clone/features/channel/my_channel/pages/my_channel_screen.dart';
import 'package:youtube_clone/features/channel/users_channel/pages/user_channel_page.dart';
import 'package:youtube_clone/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'clone-caa9a',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      // streamBuilder to check if user is logged in or not
      home: StreamBuilder(
          // stream is authStateChanges from firebase check if user is logged in or not
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // if user is not logged in show login page
              return const LoginPage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return UsernamePage(
                        displayName: user!.displayName!,
                        profilePic: user.photoURL!,
                        email: user.email!,
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Loader();
                    } else {
                      return UserChannelPage();
                    }
                  });
            }
          }),
    );
  }
}
