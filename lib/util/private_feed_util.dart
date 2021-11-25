import 'dart:convert';

import 'package:dapproh/models/skynet_schema.dart';
import 'package:hive/hive.dart';

class PrivateFeedUtil {
  static PrivateUser? user;
  static Box configBox = Hive.box("configuration");

  static PrivateUser getPrivateUser() {
    if (user == null) {
      if (configBox.get("privateUser") == '') {
        throw UnimplementedError("The private user should have been set in restore or in creation");
      } else {
        user = PrivateUser.fromJson(jsonDecode(configBox.get("privateUser")));
      }
    }
    return user!;
  }

  static void addPost(Post post) {
    if (user == null) getPrivateUser();
    user!.addPost(post);
    updatePrivateFeed();
  }

  static void updatePrivateFeed() {
    // Encrypt and update
    configBox.put("privateUser", json.encode(user!.toJson()));
  }

  static bool addUser(FollowedUser foreignUser) {
    if (user == null) getPrivateUser();

    bool userExisted = user!.addUser(foreignUser);
    updatePrivateFeed();
    return userExisted;
  }
}
