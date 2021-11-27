import 'package:dapproh/components/remote_image.dart';
import 'package:dapproh/models/public_user.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController(text: ConfigBox.getOwnedFeed().name);

    return ValueListenableBuilder(
        valueListenable: Hive.box("configuration").listenable(),
        builder: (context, value, child) => SafeArea(
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
                    Flexible(
                        child: TextField(
                      controller: userNameController,
                      onSubmitted: (String data) {
                        // update profile data
                        PublicFeed ownedFeed = ConfigBox.getOwnedFeed();
                        ownedFeed.name = data;
                        ConfigBox.setOwnedFeed(ownedFeed, setSkynet: true);
                      },
                    ))
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
                Column(
                  children: ConfigBox.getPrivateUser().following.values.map((e) => Text(e.userId)).toList(),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(ConfigBox.getOwnedFeed().posts.length,
                            (index) => RemoteImage(ConfigBox.getOwnedFeed().posts[ConfigBox.getOwnedFeed().posts.length - 1 - index]))))
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ))); //);
  }
}
