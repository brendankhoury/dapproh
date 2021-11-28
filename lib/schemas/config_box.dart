// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:cryptography/cryptography.dart';
import 'package:dapproh/controllers/user_data.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skynet/skynet.dart';
import 'package:steel_crypt/steel_crypt.dart';

import '../secret.dart' as secrets;

class ConfigBox {
  ConfigBox() {
    throw UnsupportedError("ConfigBox should not be initialized");
  }

  static const String PUBLIC_FEED_KEY = 'dapproh_public_feed';
  static const String FRIEND_FILE_KEY = 'dapproh_friend_file';

  static final Box configBox = Hive.box("configuration");
  static final Box cacheBox = Hive.box("cache");

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
    setPrivateUser(PrivateUser({}, [], publicFeedKey), setSkynet: true);
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
    return PrivateUser.fromJson(jsonDecode(privateUserData));
  }

  static Future<String> mnemonicToKey(String mnemonic) async {
    final pdfk2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 1000, bits: 256);
    final secretKey = await pdfk2.deriveKey(secretKey: SecretKey(mnemonic.codeUnits), nonce: []);
    final secretKeyData = await secretKey.extract();
    final stringKey = base64Encode(secretKeyData.bytes);
    return stringKey;
  }

  static void setPrivateUser(PrivateUser user, {required bool setSkynet}) async {
    debugPrint("SettingPrivateUser: ${jsonEncode(user.toJson())}");
    configBox.put("privateUser", jsonEncode(user.toJson()));
    // TODO: UPLOAD TO SKYNET;
    if (setSkynet) {
      String newIv = keyGen.genDart();

      String privateFeedContent = jsonEncode(user.toJson());

      AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: await mnemonicToKey(getMnemonic()));

      String encryptedPrivateFeedContent = encryption.gcm.encrypt(inp: privateFeedContent, iv: newIv);
      String ivAndContent = newIv + ' ' + encryptedPrivateFeedContent;

      bool wasSkynetSetSuccessfull = await client.skydb.setFile(await getOwnedSkynetUser(), UserDataController.PRIVATE_USER_FEED_KEY,
          SkyFile(content: Uint8List.fromList(utf8.encode(ivAndContent)), filename: "privateFeed.txt", type: "text/plain"));
      debugPrint("Successfull private feed update: $wasSkynetSetSuccessfull");
    }
  }

  static Future<SkynetUser> getOwnedSkynetUser() async {
    return await SkynetUser.fromMySkySeedRaw(getMnemonicSeed());
  }

  static PublicFeed getOwnedFeed() {
    PublicFeed ownedFeed = PublicFeed.fromJson(jsonDecode(configBox.get("ownedFeed")));
    return ownedFeed;
  }

  static Future<bool> setOwnedFeed(PublicFeed feed, {required bool setSkynet}) async {
    // debugPrint("SettingOwnedFeed, updatingSkynet: $setSkynet");
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

  static Future<bool> setProfilePicture(String imagePath) async {
    String newIv = keyGen.genDart();
    String newKey = keyGen.genFortuna();

    String newImagePath = await uploadToEstuary(imagePath, newKey, newIv);
    if (newImagePath == '') return false;
    PublicFeed ownedFeed = getOwnedFeed();
    ownedFeed.profilePicture = "https://dweb.link/ipfs/$newImagePath";
    ownedFeed.profilePictureKeyAndIv = newKey + ' ' + newIv;
    return await setOwnedFeed(ownedFeed, setSkynet: true);
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
        setPrivateUser(privateUser, setSkynet: true);
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
    // debugPrint( "RawFeedData: $rawFeedData\nEncryptedFeedString: $encryptedFeedString\nFollowedUserKey: ${user.followerKey}\nReal key: ${getPrivateUser().encryptionKey}");
    String decryptedFeedString = encryption.gcm.decrypt(enc: encryptedFeedString, iv: followedUserIv);
    // debugPrint("encryptedFeedString: $encryptedFeedString");
    // debugPrint("decryptedFeedString: $decryptedFeedString");
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

  static Future<bool> postImage(String imagePath, String description) async {
    final String encryptionKey = keyGen.genFortuna();
    final String encryptionIv = keyGen.genDart();
    final String uploadCID = await uploadToEstuary(imagePath, encryptionKey, encryptionIv);
    if (uploadCID == '') {
      throw Exception("Unable to upload file to estuary");
      return false;
    } else {
      final Post newPost = Post(DateTime.now(), description, "https://dweb.link/ipfs/$uploadCID", encryptionKey, encryptionIv);
      final PublicFeed ownedFeed = getOwnedFeed();
      ownedFeed.addPost(newPost);
      final PrivateUser privateUser = getPrivateUser();
      privateUser.addPost(newPost);
      setPrivateUser(privateUser, setSkynet: true);
      final bool skynetSet = await setOwnedFeed(ownedFeed, setSkynet: true);
      debugPrint("Skynet Set with new post: $skynetSet");
      return skynetSet;
    }
  }

  static const String estuaryEndpoint = "https://shuttle-4.estuary.tech/content/add";
  static final String estuaryAPIKey = secrets.ESTUARY_API_KEY;
  static Future<String> uploadToEstuary(String imagePath, String encryptionKey, String encryptionIv) async {
    // XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (image == null) {
    //   return "";
    // }
    final File data = File(imagePath);
    final Uint8List rawImageData = await data.readAsBytes();
    final String strImageData = base64Encode(rawImageData);

    AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: encryptionKey);
    final String encryptedImageData = encryption.gcm.encrypt(inp: strImageData, iv: encryptionIv);

    // debugPrint("rawImageData: ${strImageData.substring(0, min(300, rawImageData.length))}");
    final MultipartFile file = MultipartFile.fromString(encryptedImageData, filename: "upload.jpg");

    final FormData formData = FormData.fromMap({"data": file});
    try {
      final Response response = await Dio()
          .post(estuaryEndpoint, data: formData, options: Options(method: "post", headers: {"Authorization": "Bearer $estuaryAPIKey"}))
          .onError((error, stackTrace) {
        debugPrint("$error\n$stackTrace");
        throw UnimplementedError();
      });
      // debugPrint("Estuary Upload Response: $response\nEstuary Upload Response.body: ${response.data}");
      return response.data["cid"];
    } catch (e) {
      debugPrint("Upload failed: $e");
    }
    return "";
  }

  static Future<Uint8List> retrieveImage(String imageDataURL, String encryptionKey, String encryptionIv) async {
    if (cacheBox.containsKey(imageDataURL)) {
      // debugPrint("returning image from cache");
      return cacheBox.get(imageDataURL);
    }
    // debugPrint("image not in cache, retrieving");

    final Response response = await Dio().get(imageDataURL);
    // final String responseData = await CacheBox.get(imageDataURL);

    // debugPrint("Image response: $response");
    final AesCrypt encryption = AesCrypt(padding: PaddingAES.pkcs7, key: encryptionKey);
    String decryptedImageData = encryption.gcm.decrypt(enc: response.data, iv: encryptionIv);
    Uint8List rawDecryptedImageData = base64Decode(decryptedImageData);
    cacheBox.put(imageDataURL, rawDecryptedImageData);
    return rawDecryptedImageData;
    // throw UnimplementedError("retrieveImage not yet implemented");
  }

  static double? getImageHeight(String imageDataUrl) {
    if (cacheBox.containsKey("height:$imageDataUrl")) return 1.0 * cacheBox.get("height:$imageDataUrl");
    return null;
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
