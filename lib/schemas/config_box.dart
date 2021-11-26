// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skynet/skynet.dart';
import 'package:steel_crypt/steel_crypt.dart';

class ConfigBox {
  ConfigBox() {
    throw UnsupportedError("ConfigBox should not be initialized");
  }

  static const String PUBLIC_FEED_KEY = 'dapproh_public_feed';
  static const String FRIEND_FILE_KEY = 'dapproh_friend_file';

  static final Box configBox = Hive.box("configuration");
  static final SkynetClient client = SkynetClient();
  static final CryptKey keyGen = CryptKey();

  static String getMnemonic() => configBox.get("mnemonic");
  static Uint8List getMnemonicSeed() => mnemonicToSeed(getMnemonic());
  static void setMnemonic(String mnemonic) => configBox.put("mnemonic", mnemonic);

  static Future<String> regenerateMnemonic() async {
    String newMnemonic = generateMnemonic();
    setMnemonic(newMnemonic);
    String userId = (await getOwnedSkynetUser()).id;
    setUserId(userId);
    String publicFeedKey = keyGen.genFortuna();
    setPrivateUser(PrivateUser({}, [], publicFeedKey));
    // setPrivateUser(PrivateUser({userId: FollowedUser(publicFeedKey, userId)}, [], publicFeedKey));
    setOwnedFeed(PublicFeed([], getUserName()), setSkynet: true).then((value) {
      if (value) {
        // In this case, the friendCode is simply set
        resetFriendCode().then((value) {
          if (!value) {
            debugPrint("No Friend code set for new user!!!");
          }
        });
      }
    });

    return newMnemonic;
  }

  static PrivateUser getPrivateUser() {
    if (!configBox.containsKey("privateUser")) {
      throw UnsupportedError("PrivateUserData is null in configBox");
    }
    String privateUserData = configBox.get("privateUser");
    debugPrint("PrivateUserData: $privateUserData");
    return PrivateUser.fromJson(jsonDecode(privateUserData));
  }

  static void setPrivateUser(PrivateUser user) async {
    debugPrint("SettingPrivateUser: ${jsonEncode(user.toJson())}");
    configBox.put("privateUser", jsonEncode(user.toJson()));
    // TODO: UPLOAD TO SKYNET;
  }

  static Future<SkynetUser> getOwnedSkynetUser() async {
    return await SkynetUser.fromMySkySeedRaw(getMnemonicSeed());
  }

  static PublicFeed getOwnedFeed() => PublicFeed.fromJson(jsonDecode(configBox.get("ownedFeed")));
  static Future<bool> setOwnedFeed(PublicFeed feed, {required bool setSkynet}) async {
    debugPrint("SettingOwnedFeed, updatingSkynet: $setSkynet");
    configBox.put("ownedFeed", jsonEncode(feed.toJson()));
    if (setSkynet) {
      String newIv = keyGen.genDart();

      String publicFeedContent = jsonEncode(getOwnedFeed().toJson());

      AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: getPrivateUser().encryptionKey);

      String encryptedPublicFeedContent = encryption.gcm.encrypt(inp: publicFeedContent, iv: newIv);
      String ivAndContent = newIv + ' ' + encryptedPublicFeedContent;

      bool wasSkynetSetSuccessfull = await client.skydb.setFile(await getOwnedSkynetUser(), PUBLIC_FEED_KEY,
          SkyFile(content: Uint8List.fromList(utf8.encode(ivAndContent)), filename: "publicFeed.txt", type: "text/plain"));
      debugPrint("Successfull public feed update: $wasSkynetSetSuccessfull");
      return wasSkynetSetSuccessfull;
    }
    return true;
  }

  static Future<bool> addFriendFromCode(String friendCode) async {
    // Friend Key construction:     return userId + ' ' + friendKey + ' ' + friendIv;
    final List<String> splitData = friendCode.split(" ");
    final String friendId = splitData[0];
    final String friendFileKey = splitData[1];
    final String friendIv = splitData[2];

    final SkynetUser friendUser = SkynetUser.fromId(friendId);
    final SkyFile friendFile = await client.skydb.getFile(friendUser, FRIEND_FILE_KEY);

    final AesCrypt friendFileEncryption = AesCrypt(padding: PaddingAES.pkcs7, key: friendFileKey);
    if (friendFile.asString != null) {
      final String friendKey = friendFileEncryption.gcm.decrypt(enc: friendFile.asString!, iv: friendIv).substring(0, 44);
      debugPrint("DecryptedFriendFile: $friendKey");
      final newUser = FollowedUser(friendKey, friendId);
      try {
        getFeedFromUser(newUser); // Verifies the autenthicity of the file, will throw an error otherwise
        final privateUser = getPrivateUser();
        privateUser.addUser(newUser);
        setPrivateUser(privateUser);
        return true;
      } catch (e) {
        debugPrint("Failure Adding user: $e");
      }
    } else {
      throw Error();
    }

    return false;
  }

  static Future<PublicFeed> getFeedFromUser(FollowedUser user) async {
    List<String> rawFeedData = (await client.skydb.getFile(SkynetUser.fromId(user.userId), ConfigBox.PUBLIC_FEED_KEY)).asString.toString().split(' ');
    String followedUserIv = rawFeedData[0];
    String encryptedFeedString = rawFeedData[1];
    AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: user.followerKey);
    debugPrint(
        "RawFeedData: $rawFeedData\nEncryptedFeedString: $encryptedFeedString\nFollowedUserKey: ${user.followerKey}\nReal key: ${getPrivateUser().encryptionKey}");
    String decryptedFeedString = encryption.gcm.decrypt(enc: encryptedFeedString, iv: followedUserIv);
    debugPrint("encryptedFeedString: $encryptedFeedString");
    debugPrint("decryptedFeedString: $decryptedFeedString");
    return PublicFeed.fromJson(jsonDecode(decryptedFeedString));
  }

  static String getFriendCode() {
    // return getFriendCode(ConfigBox.getFriendKey(), ConfigBox.getFriendIv(), ConfigBox.getUserId());
    return getUserId() + ' ' + getFriendKey() + ' ' + getFriendIv();
  }

  static Future<bool> resetFriendCode() async {
    debugPrint("Starting resetFriendCode");
    final String friendKey = keyGen.genFortuna();
    final String friendIv = keyGen.genDart();
    final AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: friendKey);

    ConfigBox.setFriendKey(friendKey);
    ConfigBox.setFriendIv(friendIv);

    encryption.gcm.encrypt(inp: friendKey, iv: friendIv);

    final SkynetUser user = await SkynetUser.fromMySkySeedRaw(getMnemonicSeed());
    final PrivateUser privateUser = getPrivateUser();

    final String encryptedEncryptionKey = encryption.gcm.encrypt(inp: privateUser.encryptionKey + keyGen.genDart(), iv: friendIv);
    final String ivAndContent = encryptedEncryptionKey;

    final bool friendFileSet = await client.skydb.setFile(
        user,
        FRIEND_FILE_KEY,
        SkyFile(
            content: Uint8List.fromList(utf8.encode(ivAndContent)),
            // By adding a dart to the end, brute forcing the key is much more difficult (the friend file will change contents every time rather than only changing the key, the dart only serves as additional randomness.)
            filename: "friend.txt",
            type: "text/plain"));
    debugPrint("friendFileSet: $friendFileSet\nReset friend code finished");
    return friendFileSet;
  }

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
