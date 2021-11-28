import 'dart:typed_data';

import 'package:dapproh/components/remote_image.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/models/public_user.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController(text: ConfigBox.getOwnedFeed().name);

    return ValueListenableBuilder(
        valueListenable: Hive.box("configuration").listenable(),
        builder: (context, value, child) {
          PublicFeed ownedFeed = ConfigBox.getOwnedFeed();
          return SafeArea(
              // child: Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    child: Container(
                        child: CircleAvatar(
                          child: ownedFeed.profilePicture == null
                              ? null
                              : FutureBuilder(
                                  future: ConfigBox.retrieveImage(ownedFeed.profilePicture!, ownedFeed.profilePictureKeyAndIv!.split(' ')[0],
                                      ownedFeed.profilePictureKeyAndIv!.split(' ')[1]),
                                  builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return CircleAvatar(
                                        radius: 38,
                                        backgroundImage: Image.memory(snapshot.data!).image, //todo: implement the post avatar thingy
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                          backgroundColor: CupertinoColors.white,
                          radius: 40,
                        ),
                        margin: const EdgeInsets.all(10)),
                    onTap: () async {
                      try {
                        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image == null) {
                          return;
                        }
                        bool pictureSet = await ConfigBox.setProfilePicture(image.path);
                        debugPrint("Successfully Set Profile Picture: $pictureSet");
                      } catch (e) {
                        debugPrint("Error selecting image $e");
                      }
                    },
                  ),
                  Flexible(
                      child: Container(
                    child: TextField(
                      decoration: const InputDecoration(border: InputBorder.none),
                      controller: userNameController,
                      onSubmitted: (String data) {
                        // update profile data
                        debugPrint("Changing userName to $data");
                        PublicFeed ownedFeed = ConfigBox.getOwnedFeed();
                        ownedFeed.name = data;
                        ConfigBox.setOwnedFeed(ownedFeed, setSkynet: true);
                      },
                    ),
                    margin: const EdgeInsets.only(right: 12),
                  )),
                  InkWell(
                    child: Container(
                        child: Column(
                          children: const [Icon(Icons.person), Text("Following")],
                        ),
                        margin: const EdgeInsets.only(right: 10)),
                    onTap: () {
                      NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                      navigation.changeScreen("/home/following");
                    },
                  ),
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
                        // debugPrint("Share friend code not yet implemented");
                        Share.share(ConfigBox.getFriendCode());
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
              // Column(
              //   children: ConfigBox.getPrivateUser().following.values.map((e) => Text(e.userId)).toList(),
              // ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(ConfigBox.getOwnedFeed().posts.length,
                          (index) => RemoteImage(ConfigBox.getOwnedFeed().posts[ConfigBox.getOwnedFeed().posts.length - 1 - index]))))
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ));
        }); //);
  }
}
