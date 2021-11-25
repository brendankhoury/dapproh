// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:dapproh/controllers/user_data.dart';
import 'package:dapproh/models/owned_feed.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skynet/skynet.dart';
import 'package:steel_crypt/steel_crypt.dart';

class PublicFeedUtil {
  static const String PUBLIC_FEED_KEY = 'dapproh_public_feed';
  static const String PUBLIC_FEED_IV_KEY = 'dapproh_public_feed_iv';

  static const String FRIEND_FILE_KEY = 'dapproh_friend_file';
  static const String FRIEND_FILE_IV_KEY = 'dapproh_friend_file_iv';

  static final CryptKey keyGen = CryptKey();
  static final Box configBox = Hive.box("configuration");

  static Future<bool> makePost(Post post) async {
    // Update local public feed instance;
    // call updatePublicFeed.
    PublicFeed feed = OwnedFeed.getFeed();
    feed.addPost(post);
    OwnedFeed.setFeed(feed);
    configBox.put("ownedFeed", jsonEncode(feed.toJson()));
    return await updatePublicFeed();
  }

  static Future<bool> updatePublicFeed() async {
    SkynetClient client = SkynetClient();
    SkynetUser user = await SkynetUser.fromMySkySeedRaw(configBox.get("mnemonic"));

    String newIv = keyGen.genDart();
    bool ivSet = await client.skydb
        .setFile(user, PUBLIC_FEED_IV_KEY, SkyFile(content: Uint8List.fromList(utf8.encode(newIv)), filename: "newIvFile", type: "text/plain"));

    if (ivSet) {
      debugPrint("PUBLIC FEED IV SET SUCCESS");
      String publicFeedContent = jsonEncode(OwnedFeed.getFeed().toJson());

      AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: PrivateUser.fromJson(jsonDecode(configBox.get("privateUser"))).encryptionKey);

      String encryptedPublicFeedContent = encryption.gcm.encrypt(inp: publicFeedContent, iv: newIv);

      bool publicFeedSet =
          await client.skydb.setFile(user, PUBLIC_FEED_KEY, SkyFile(content: Uint8List.fromList(utf8.encode(encryptedPublicFeedContent))));

      if (publicFeedSet) {
        debugPrint("Successfull post");
        return true;
      } else {
        debugPrint("Post failed");
      }
    } else {
      debugPrint("PUBLIC FEED IV SET FAILURE\n Post Failed");
    }
    return false;
  }

  static Future<String> resetFriendCode(BuildContext context) async {
    debugPrint("Starting resetFriendCode");
    // Generate key
    // encrypt public feed key with newly generated key.
    // return data
    String friendKey = keyGen.genFortuna();
    String friendIv = keyGen.genDart();
    AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: friendKey);

    configBox.put("friendKey", friendKey);
    configBox.put("friendIv", friendIv); // Since the keys
    encryption.gcm.encrypt(inp: friendKey, iv: friendIv);

    SkynetUser user = await SkynetUser.fromMySkySeedRaw(mnemonicToSeed(configBox.get("mnemonic")));
    PrivateUser privateUser = PrivateUser.fromJson(jsonDecode(configBox.get("privateUser")));

    String encryptedEncryptionKey = encryption.gcm.encrypt(inp: privateUser.encryptionKey, iv: friendIv);

    UserDataController userDataController = Provider.of<UserDataController>(context, listen: false);
    SkynetClient skynetClient = SkynetClient();

    bool friendIvSet = await skynetClient.skydb
        .setFile(user, FRIEND_FILE_KEY, SkyFile(content: Uint8List.fromList(utf8.encode(friendIv)), filename: "friendIv.txt", type: "text/plain"));
    bool friendFileSet = await skynetClient.skydb.setFile(
        user,
        UserDataController.PRIVATE_USER_FEED_KEY,
        SkyFile(
            content: Uint8List.fromList(utf8.encode(encryptedEncryptionKey + ' ' + keyGen.genDart())),
            // By adding a dart to the end, brute forcing the key is much more difficult (the friend file will change contents every time rather than only changing the key, the dart only serves as additional randomness.)
            filename: "friend.txt",
            type: "text/plain"));
    debugPrint("friendIvSet: $friendIvSet\nfriendFileSet: $friendFileSet\nReset friend code finished");
    return getFriendCode(friendKey, friendIv, user.id);
  }

  static String getFriendCode(String friendKey, String friendIv, String userId) {
    return userId + ' ' + friendKey + ' ' + friendIv;
  }

  static String getFriendCodeFromBox() {
    return getFriendCode(configBox.get("friendKey"), configBox.get("friendIv"), configBox.get("userId"));
  }
}