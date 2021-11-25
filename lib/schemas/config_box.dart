import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:dapproh/models/owned_feed.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:hive/hive.dart';

class ConfigBox {
  static Box configBox = Hive.box("configuration");

  static String getMnemonic() => configBox.get("mnemonic");
  static Uint8List getMnemonicSeed() => mnemonicToSeed(getMnemonic());
  static void setMnemonic(String mnemonic) => configBox.put("mnemonic", mnemonic);

  static PrivateUser getPrivateUser() {
    String privateUserData = configBox.get("privateUser");
    if (privateUserData == '') {
      throw UnsupportedError("PrivateUserData is null in configBox");
    }
    return PrivateUser.fromJson(jsonDecode(privateUserData));
  }

  static void setPrivateUser(PrivateUser user) => configBox.put("privateUser", jsonEncode(user.toJson()));

  static PublicFeed getOwnedFeed() => PublicFeed.fromJson(jsonDecode(configBox.get("ownedFeed")));
  static void setOwnedFeed(PublicFeed feed) => configBox.put("ownedFeed", jsonEncode(feed.toJson()));

  // static PublicFeed getPublicFeed()
  static String getFriendKey() => configBox.get("friendKey");
  static void setFriendKey(String key) => configBox.put("friendKey", key);

  static String getFriendIv() => configBox.get("friendIv");
  static void setFriendIv(String iv) => configBox.put("friendIv", iv);

  static String getUserId() => configBox.get("userId");
  static void setUserId(String id) => configBox.put("userId", id);
}
