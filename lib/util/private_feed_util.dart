// import 'dart:convert';

// import 'package:dapproh/models/skynet_schema.dart';
// import 'package:dapproh/schemas/config_box.dart';
// import 'package:hive/hive.dart';

// class PrivateFeedUtil {
//   static PrivateUser? user;

//   static PrivateUser getPrivateUser() {
//     user ??= ConfigBox.getPrivateUser();
//     return user!;
//   }

//   static void addPost(Post post) {
//     if (user == null) getPrivateUser();
//     user!.addPost(post);
//     updatePrivateFeed();
//   }

//   static void updatePrivateFeed() {
//     // Encrypt and update
//     ConfigBox.setPrivateUser(user!);
//   }

//   static bool addUser(FollowedUser foreignUser) {
//     if (user == null) getPrivateUser();

//     bool userExisted = user!.addUser(foreignUser);
//     updatePrivateFeed();
//     return userExisted;
//   }
// }
