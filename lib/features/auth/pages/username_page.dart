// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/auth/repository/user_data_service.dart';

final formKey = GlobalKey<FormState>();

class UsernamePage extends ConsumerStatefulWidget {
  final String displayName;
  final String profilePic;
  final String email;
  const UsernamePage({
    super.key,
    required this.displayName,
    required this.profilePic,
    required this.email,
  });

  @override
  ConsumerState<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends ConsumerState<UsernamePage> {
  final usernameController = TextEditingController();
  bool isValidate = true;
  Future<void> validateUserName() async {
    // Fetch all usernames from Firestore
    final usersMap = await FirebaseFirestore.instance.collection('users').get();
    final users =
        usersMap.docs.map((user) => user.data()['username'] as String).toList();

    // Check if the entered username already exists
    if (users.contains(usernameController.text)) {
      isValidate = false;
    } else {
      isValidate = true;
    }

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, left: 20, bottom: 10),
            child: Text(
              'Enter the username',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              child: TextFormField(
                onChanged: (value) {
                  // check if username is valid
                  validateUserName();
                },
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  return isValidate ? null : 'Username already taken';
                },
                key: formKey,
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  suffixIcon: Icon(
                    isValidate ? Icons.verified_user : Icons.cancel,
                  ),
                  suffixIconColor: isValidate ? Colors.green : Colors.red,
                  hintText: 'Enter username',
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isValidate ? Colors.green : Colors.red)),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            child: FlatButton(
                text: 'Continue',
                onPressed: () async {
                  // add userdata to firestore
                  isValidate
                      ? await ref
                          .read(userDataServiceProvider)
                          .addUserDataToFirestore(
                            displayName: widget.displayName,
                            username: usernameController.text,
                            email: widget.email,
                            profilePic: widget.profilePic,
                            description: '',
                          )
                      : null;
                },
                colour: isValidate ? Colors.green : Colors.green.shade100),
          )
        ],
      )),
    );
  }
}
