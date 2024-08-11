import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/channel/my_channel/repository/edit_fields.dart';
import 'package:youtube_clone/features/channel/my_channel/widgets/edit_setting_dialog.dart';
import 'package:youtube_clone/features/channel/my_channel/widgets/setting_field_item.dart';

class ChannelSettings extends ConsumerStatefulWidget {
  const ChannelSettings({super.key});

  @override
  ConsumerState<ChannelSettings> createState() => _ChannelSettingsState();
}

class _ChannelSettingsState extends ConsumerState<ChannelSettings> {
  bool isValidate = true;

  Future<void> validateUserName(String name) async {
    // Fetch all usernames from Firestore
    final usersMap = await FirebaseFirestore.instance.collection('users').get();
    final users =
        usersMap.docs.map((user) => user.data()['username'] as String).toList();

    // Check if the entered username already exists
    if (users.contains(name)) {
      isValidate = false;
    } else {
      isValidate = true;
    }
    // print('bool is$isValidate');

    // Update the UI
    setState(() {});
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return ref.watch(currentUserProvider).when(
          data: (user) {
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                                height: 160,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/flutter background.png',
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                              left: 170,
                              top: 55,
                              child: CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(user.profilePic),
                                radius: 30,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              height: 35,
                              child: IconButton(
                                  onPressed: () {
                                    // ImagePicker()
                                    //     .pickImage(source: ImageSource.gallery)
                                    //     .then(
                                    //   (value) async {
                                    //     if (value != null) {
                                    //        await ref
                                    //           .watch(editSettingsProvider)
                                    //           .editProfilePic(value);
                                    //     }
                                    //   },
                                    // );
                                  },
                                  icon: const Icon(
                                    Icons.camera_enhance_rounded,
                                  ),
                                  iconSize: 30,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // second part
                        SettingsItem(
                            identifier: 'Name',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => SettingsDialog(
                                  identifier: 'Your new name',
                                  onSave: (value) => ref
                                      .watch(editSettingsProvider)
                                      .editDisplayName(value),
                                ),
                              );
                            },
                            value: user.displayName),
                        const SizedBox(height: 10),
                        SettingsItem(
                            identifier: 'Your new username',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => SettingsDialog(
                                  identifier: 'Username',
                                  onSave: (value) async {
                                    await validateUserName(value);
                                    return isValidate
                                        ? await ref
                                            .read(editSettingsProvider)
                                            .editUserName(value)
                                        : Fluttertoast.showToast(
                                            msg: 'Username already taken',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                          );
                                  },
                                ),
                              );
                            },
                            value: user.username),
                        const SizedBox(height: 10),

                        SettingsItem(
                            identifier: 'Your new description',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => SettingsDialog(
                                  identifier: 'Description',
                                  onSave: (value) => ref
                                      .watch(editSettingsProvider)
                                      .editDiscription(value),
                                ),
                              );
                            },
                            value: user.description),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Keep all my subscribers private',
                                style: TextStyle(fontSize: 17),
                              ),
                              Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    isSwitched = value;
                                    setState(() {});
                                  }),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            textAlign: TextAlign.justify,
                            'Changes made on your names and profile are only visible to youtube and not other google services',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stack) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}
