import 'package:dapproh/schemas/config_box.dart';
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
                  Clipboard.setData(ClipboardData(text: ConfigBox.getFriendCode()));
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
              ConfigBox.resetFriendCode();
            },
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          ),
        ),
        Center(
          child: ElevatedButton(
            child: const Text("Add friend from clipboard"),
            onPressed: () async {
              ClipboardData? data = await Clipboard.getData("text/plain");
              if (data != null && data.text != null) {
                debugPrint("ClipboardData: ${data.text}");
                try {
                  ConfigBox.addFriendFromCode(data.text!);
                } catch (e) {
                  debugPrint("Failure to add friend from clipboard: ${data.text} and the error was :::: $e");
                }
              } else {
                debugPrint("No clipboard data");
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
