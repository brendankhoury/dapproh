// ignore_for_file: constant_identifier_names
//                  ^^^ side note, really annoying

import 'dart:convert';
import 'dart:typed_data';

import 'package:dapproh/models/skynet_schema.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/material.dart';
import 'package:skynet/skynet.dart';
import 'package:steel_crypt/steel_crypt.dart';

class UserDataController extends ChangeNotifier {
  late SkynetUser user;
  late String privateDataKey;
  int feedAttempt = 0;
  // static const String PRIVATE_USER_IV_KEY = 'dapproh_private_user_iv';
  static const String PRIVATE_USER_FEED_KEY = 'dapproh_private_user_feed';

  final SkynetClient skynetClient = SkynetClient();
  Feed feed = Feed();

  void initUser() async {
    populateFeed();

    // No need anymore, require user to be initialized at this point.
    // String mnemonic = ConfigBox.getMnemonic();
    // // Check box for local private user
    // // Check box for local public  user
    // // Load private profile and send out data

    // PrivateUser privateUser = ConfigBox.getPrivateUser();

    // // The following line is not really necessary
    // // String publicUserData = configBox.get("publicFeed");

    // // TODO: Move to another file
    // privateDataKey = await EncUtil.mnemonicToKey(mnemonic);

    // // Check if the private user exists in box.
    // user = await ConfigBox.getOwnedSkynetUser();

    // ConfigBox.setUserId(user.id);
    // try {
    //   await skynetClient.skydb.getFile(user, PRIVATE_USER_FEED_KEY).then(onPrivateContentRetrieve); //1.onError(onContentRetrievalFailure);
    // } catch (e) {
    //   onContentRetrievalFailure(e);
    // }
  }

  void populateFeed() {
    feedAttempt++;
    feed = Feed();
    final int localAttempt = feedAttempt;
    Map<String, FollowedUser> following = ConfigBox.getPrivateUser().following;
    // debugPrint("PopulateFeed called, $following");
    following.forEach((key, value) async {
      try {
        // debugPrint("Followed user retieval\n");
        final PublicFeed recievedFeed = await ConfigBox.getFeedFromUser(value);
        if (localAttempt == feedAttempt) {
          feed.addPosts(recievedFeed.posts);
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error retrieving followed user $e");
      }
    });
  }

  void onPrivateContentRetrieve(content) async {
    if (content.asString == null) {
      debugPrint("Peepo Panic, null file content");
      debugPrint("${content.asString}");
    } else {
      // String privateIv16 = configBox.get("privateIv16");
      debugPrint("privateUserFeed: ${content.asString}");

      AesCrypt encryption = AesCrypt(key: privateDataKey, padding: PaddingAES.pkcs7);

      String decryptedContent = encryption.gcm.decrypt(
          enc: content.asString.toString().substring(content.asString.toString().indexOf(' ') + 1),
          iv: content.asString.toString().substring(0, content.asString.toString().indexOf(' ')));
      debugPrint("privateUserFeed: decrypted content $decryptedContent");

      Map<String, dynamic> decodedJson = jsonDecode(decryptedContent);

      PrivateUser privateUserFeed = PrivateUser.fromJson(decodedJson);
      debugPrint("Accessing private user feed: ${privateUserFeed.encryptionKey}");
    }
  }

  void onContentRetrievalFailure(error) async {
    debugPrint("Failure ${error.toString()}\n Runtimetype: ${error.runtimeType}");
    if (error.toString() == "Exception: not found") {
      debugPrint("Not found exception, creating a new file");
      CryptKey keyGen = CryptKey();

      PrivateUser privateUser = PrivateUser({}, [], keyGen.genFortuna());
      AesCrypt encryption = AesCrypt(key: privateDataKey, padding: PaddingAES.pkcs7);
      String privateUserString = jsonEncode(privateUser);
      ConfigBox.setPrivateUser(privateUser);
      String privateIv16 = keyGen.genDart();

      await skynetClient.skydb
          .setFile(
              user,
              PRIVATE_USER_FEED_KEY,
              SkyFile(
                  content: Uint8List.fromList(utf8.encode(privateIv16 + ' ' + encryption.gcm.encrypt(inp: privateUserString, iv: privateIv16))),
                  filename: "private.txt",
                  type: "text/plain"))
          .then((value) => debugPrint("$value, private.txt file set"))
          .onError((error, stackTrace) => debugPrint("${error.toString()} ${stackTrace.toString()}"));
    } else {
      debugPrint("Exception not identified: ${error.toString()}");
    }
  }

  void updateUser(/* data */) {
    // Change initialization vector .txt
    // update user private.txt
    throw UnimplementedError("UserData.updateUser not implemented");
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
