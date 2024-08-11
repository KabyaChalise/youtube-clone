import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/colors.dart';
import 'package:youtube_clone/cores/widgets/image_button.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: softBlueGreyBackGround,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text('Manage Videos',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
          ),
          Expanded(
              child: ImageButton(
                  onPressed: () {}, image: 'pen.png', haveColor: true)),
          Expanded(
              child: ImageButton(
                  onPressed: () {},
                  image: 'time-watched.png',
                  haveColor: true)),
        ],
      ),
    );
  }
}
