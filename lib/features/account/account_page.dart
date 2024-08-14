// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:youtube_clone/features/account/items.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';

class AccountPage extends StatelessWidget {
  final UserModel user;
  const AccountPage({
    Key? key,
    required this.user,
  }) : super(key: key);

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
                 IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
                 Column(
                  children: [
                     CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(user.profilePic),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.displayName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.username,
                        style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 20),
                  ],
                 )
                ],
              ),
              const Items(),
              
            ],
          ),
        ),
      ),
    );
  }
}
