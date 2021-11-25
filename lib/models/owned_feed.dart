// import 'dart:convert';

// import 'package:dapproh/models/public_user.dart';
// import 'package:hive/hive.dart';

// class OwnedFeed {
//   // This model is useless

//   static PublicFeed? feed;
//   static Box configBox = Hive.box("configuratio_____n");
//   static PublicFeed getFeed() {
//     if (feed == null) {
//       String? feedContent = configBox.get("ownedFeed");
//       if (feedContent == null) {
//         feed = PublicFeed([], "Name");
//       } else {
//         feed = PublicFeed.fromJson(jsonDecode(feedContent));
//       }
//     }
//     return feed!;
//   }

//   static void setFeed(PublicFeed newFeed) {
//     feed = newFeed;
//     configBox.put("ownedFeed", json.encode(newFeed.toJson()));
//   }
// }
