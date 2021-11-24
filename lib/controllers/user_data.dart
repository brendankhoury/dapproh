// ignore_for_file: constant_identifier_names
//                  ^^^ side note, really annoying

import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skynet/skynet.dart';
import 'package:steel_crypt/steel_crypt.dart';
import 'dart:convert' as ConvertPack;
import '../util/enc_util.dart';

class UserDataController extends ChangeNotifier {
  late SkynetUser user;
  static const String PRIVATE_USER_FEED_KEY = 'user_feed';

  SkynetClient skynetClient = SkynetClient();
  Feed feed = Feed();

  void initUser() async {
    String mnemonic = Hive.box("configuration").get("mnemonic");
    String key = await EncUtil.mnemonicToKey(mnemonic);

    assert(validateMnemonic(mnemonic));

    // Check if the private user exists in box.
    user = await SkynetUser.fromMySkySeedRaw(mnemonicToSeed(mnemonic));

    try {
      debugPrint(mnemonicToSeedHex(mnemonic));
      await skynetClient.skydb.getFile(user, PRIVATE_USER_FEED_KEY).then(onPrivateContentRetrieve); //1.onError(onContentRetrievalFailure);
    } catch (e) {
      onContentRetrievalFailure(e);
    }
  }

  void onPrivateContentRetrieve(content) async {
    if (content.asString == null) {
      debugPrint("Peepo Panic, null file content");
      debugPrint("${content.asString}");
    } else {
      Box configBox = Hive.box("configuration");

      String public_iv16 = configBox.get("publicIv16");
      debugPrint("privateUserFeed: ${content.asString}");

      AesCrypt encryption = AesCrypt(key: await EncUtil.mnemonicToKey(configBox.get("mnemonic")), padding: PaddingAES.pkcs7);
      debugPrint("privateUserFeed: post encryption");

      String decryptedContent = encryption.gcm.decrypt(enc: content.asString, iv: public_iv16);
      debugPrint("privateUserFeed: decrypted content ${decryptedContent}");

      Map<String, dynamic> decodedJson = jsonDecode(decryptedContent);

      PrivateUser privateUserFeed = PrivateUser.fromJson(decodedJson);
      debugPrint("Accessing private user feed: ${privateUserFeed.encryptionKey}");
    }
  }

  void onContentRetrievalFailure(error) async {
    debugPrint("Failure ${error.toString()}\n Runtimetype: ${error.runtimeType}");
    if (error.toString() == "Exception: not found") {
      debugPrint("Not found exception, creating a new file");
      Box configBox = Hive.box("configuration");
      CryptKey keyGen = CryptKey();

      PrivateUser privateUser = PrivateUser({}, [], keyGen.genFortuna());
      AesCrypt encryption = AesCrypt(key: await EncUtil.mnemonicToKey(configBox.get("mnemonic")), padding: PaddingAES.pkcs7);
      String privateUserString = jsonEncode(privateUser);
      configBox.put("privateUser", privateUserString);
      String public_iv16 = keyGen.genDart();

      configBox.put("publicIv16", public_iv16);
      await skynetClient.skydb
          .setFile(user, PRIVATE_USER_FEED_KEY,
              SkyFile(content: Uint8List.fromList(utf8.encode(public_iv16)), filename: "public_iv16.txt", type: "text/plain"))
          .then((value) => debugPrint("$value, initialization vector file set"))
          .onError((error, stackTrace) => debugPrint("${error.toString()} ${stackTrace.toString()}"));
      await skynetClient.skydb
          .setFile(
              user,
              PRIVATE_USER_FEED_KEY,
              SkyFile(
                  content: Uint8List.fromList(utf8.encode(encryption.gcm.encrypt(inp: privateUserString, iv: public_iv16))),
                  filename: "private.txt",
                  type: "text/plain"))
          .then((value) => debugPrint("$value, private.txt file set"))
          .onError((error, stackTrace) => debugPrint("${error.toString()} ${stackTrace.toString()}"));
    } else {
      debugPrint("Exception not identified: ${error.toString()}");
    }
  }

  /*
  Adds posts to feed and notifies the listeners
  Future, potentially store the posts in box if they do not exist already.
  
  @effects feed 
  @effects any listeners are notified 
  @param List<Post> posts, the posts to be added;

  */
  void addToFeed(List<Post> posts) {
    feed.addPosts(posts);
    notifyListeners();
  }
}
