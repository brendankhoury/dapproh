import 'package:dapproh/util/public_feed_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        // child: Expanded(
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
              margin: const EdgeInsets.all(10),
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
                  Clipboard.setData(ClipboardData(text: PublicFeedUtil.getFriendCodeFromBox()));
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
            child: const Text("Reset friend code"),
            onPressed: () {
              PublicFeedUtil.resetFriendCode(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          ),
        ),
        Center(
          child: ElevatedButton(
            child: const Text("Add friend from clipboard"),
            onPressed: () async {
              ClipboardData? data = await Clipboard.getData("text/plain");
              if (data != null) {
                debugPrint("ClipboardData: ${data.text}");
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
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
    )); //);
  }
}
