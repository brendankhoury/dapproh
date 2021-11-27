import 'dart:typed_data';

import 'package:dapproh/models/followed_user.dart';
import 'package:dapproh/models/public_user.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FollowedUser> users = ConfigBox.getPrivateUser().following.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Following:"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<PublicFeed> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Row(
                  children: [
                    Container(
                        child: CircleAvatar(
                          child: snapshot.data!.profilePicture == null
                              ? null
                              : FutureBuilder(
                                  future: ConfigBox.retrieveImage(snapshot.data!.profilePicture!,
                                      snapshot.data!.profilePictureKeyAndIv!.split(' ')[0], snapshot.data!.profilePictureKeyAndIv!.split(' ')[1]),
                                  builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return CircleAvatar(
                                        backgroundImage: Image.memory(snapshot.data!).image, //todo: implement the post avatar thingy
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                          backgroundColor: CupertinoColors.white,
                          radius: 22,
                        ),
                        margin: const EdgeInsets.only(right: 5)),
                    Text("${snapshot.data!.name}")
                  ],
                );
              }
              return Text("Loading: ${users[index].userId}");
            },
            future: ConfigBox.getFeedFromUser(users[index]),
          ));
        },
        itemCount: users.length,
      ),
    );
  }
}
