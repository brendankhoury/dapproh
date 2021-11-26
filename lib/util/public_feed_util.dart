// ignore_for_file: constant_identifier_names
import 'package:dapproh/models/skynet_schema.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:steel_crypt/steel_crypt.dart';

class PublicFeedUtil {
  // static const String PUBLIC_FEED_KEY = 'dapproh_public_feed';
  // static const String FRIEND_FILE_KEY = 'dapproh_friend_file';

  static final CryptKey keyGen = CryptKey();

  static Future<bool> makePost(Post post) async {
    // Update local public feed instance;
    // call updatePublicFed.
    PublicFeed feed = ConfigBox.getOwnedFeed();
    feed.addPost(post);
    return await ConfigBox.setOwnedFeed(feed, setSkynet: true);
  }

  // static Future<String> resetFriendCode(BuildContext context) async {
  //   bool friendCodeSet = await ConfigBox.resetFriendCode();
  //   if (!friendCodeSet) {
  //     debugPrint("Warning, friend code reset failed");
  //   }
  //   return ConfigBox.getFriendCode();
  // }

  // static String getFriendCode(String friendKey, String friendIv, String userId) {
  //   return userId + ' ' + friendKey + ' ' + friendIv;
  // }
}
