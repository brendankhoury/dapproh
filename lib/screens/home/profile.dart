import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Expanded(
            child: Column(
      children: [
        Row(
          children: [
            Container(
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: CupertinoColors.white,
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage("https://picsum.photos/100"),
                ),
              ),
              margin: EdgeInsets.all(10),
            ),
            const Text(
              "Profile Name",
              textScaleFactor: 1.5,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  debugPrint("Copy friend code not yet implemented");
                },
                child: const Text(
                  "Copy friend code",
                ),
                style: OutlinedButton.styleFrom(primary: CupertinoColors.white)),
            OutlinedButton(
                onPressed: () {
                  debugPrint("Share friend code not yet implemented");
                },
                child: const Icon(CupertinoIcons.share),
                style: OutlinedButton.styleFrom(primary: CupertinoColors.white))
          ],
        ),
        Center(
          child: ElevatedButton(
            child: Text("Reset friend code"),
            onPressed: () {
              debugPrint("Reset friend code not yet implemented");
            },
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          ),
        ),
        Center(
            child: TextButton(
          onPressed: () {
            debugPrint("How do friend codes work not yet implemented");
          },
          child: const Text(
            "What are friend codes?",
          ),
          style: TextButton.styleFrom(primary: CupertinoColors.white),
        )),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    )));
  }
}
