import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skynet/skynet.dart';
import 'package:steel_crypt/steel_crypt.dart';

class ConfigBox {
  static const String PUBLIC_FEED_KEY = 'dapproh_public_feed';

  static Box configBox = Hive.box("configuration");

  static String getMnemonic() => configBox.get("mnemonic");
  static Uint8List getMnemonicSeed() => mnemonicToSeed(getMnemonic());
  static void setMnemonic(String mnemonic) => configBox.put("mnemonic", mnemonic);

  static Future<String> regenerateMnemonic() async {
    String newMnemonic = generateMnemonic();
    setMnemonic(newMnemonic);
    CryptKey keyGen = CryptKey();
    setOwnedFeed(PublicFeed([], getUserName()), setSkynet: true);
    String userId = (await getOwnedSkynetUser()).id;
    setUserId(userId);
    String publicFeedKey = keyGen.genFortuna();
    debugPrint("Pre setting private user");
    setPrivateUser(PrivateUser({userId: FollowedUser(publicFeedKey, userId)}, [], publicFeedKey));

    debugPrint("Post setting private user");
    PrivateUser testUser = getPrivateUser();
    return newMnemonic;
  }

  static Future<bool> setSkynetData() async {
    throw UnimplementedError();
  }

  static PrivateUser getPrivateUser() {
    debugPrint("RetrievingPrivateUser");
    if (!configBox.containsKey("privateUser")) {
      throw UnsupportedError("PrivateUserData is null in configBox");
    }
    String privateUserData = configBox.get("privateUser");
    debugPrint("PrivateUserData: $privateUserData");
    return PrivateUser.fromJson(jsonDecode(privateUserData));
  }

  static void setPrivateUser(PrivateUser user) async {
    configBox.put("privateUser", jsonEncode(user.toJson()));
    // Update in skynet
  }

  static Future<SkynetUser> getOwnedSkynetUser() async {
    return await SkynetUser.fromMySkySeedRaw(getMnemonicSeed());
  }

  static PublicFeed getOwnedFeed() => PublicFeed.fromJson(jsonDecode(configBox.get("ownedFeed")));
  static Future<bool> setOwnedFeed(PublicFeed feed, {required bool setSkynet}) async {
    debugPrint("SettingOwnedFeed, updatingSkynet?: $setSkynet");
    configBox.put("ownedFeed", jsonEncode(feed.toJson()));
    if (setSkynet) {
      String newIv = CryptKey().genDart();

      String publicFeedContent = jsonEncode(getOwnedFeed().toJson());

      AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: PrivateUser.fromJson(getPrivateUser().toJson()).encryptionKey);

      String encryptedPublicFeedContent = encryption.gcm.encrypt(inp: publicFeedContent, iv: newIv);
      String ivAndContent = newIv + ' ' + encryptedPublicFeedContent;

      bool wasSkynetSetSuccessfull = await SkynetClient().skydb.setFile(await getOwnedSkynetUser(), PUBLIC_FEED_KEY,
          SkyFile(content: Uint8List.fromList(utf8.encode(ivAndContent)), filename: "publicFeed.txt", type: "text/plain"));
      debugPrint("Successfull public feed update?: $wasSkynetSetSuccessfull");
      return wasSkynetSetSuccessfull;
    }
    return true;
  }

  // static PublicFeed getPublicFeed()
  static String getFriendKey() => configBox.get("friendKey");
  static void setFriendKey(String key) => configBox.put("friendKey", key);

  static String getFriendIv() => configBox.get("friendIv");
  static void setFriendIv(String iv) => configBox.put("friendIv", iv);

  static String getUserId() => configBox.get("userId");
  static void setUserId(String id) => configBox.put("userId", id);

  static String getUserName() {
    if (!configBox.containsKey("name")) {
      setUserName("Unknown Name");
    }
    return configBox.get("name");
  }

  static void setUserName(String name) {
    configBox.put("name", name);
  }
}
