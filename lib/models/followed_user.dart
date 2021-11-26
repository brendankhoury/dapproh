import 'package:dapproh/models/public_user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skynet/skynet.dart';
part 'followed_user.g.dart';

@JsonSerializable()
class FollowedUser {
  // String feedLocation; // Location of skynet, in the future users should be able to choose. Will  require an update to the friend code
  String followerKey; // Used to decrypt the feed
  String userId; // Used to find the feed on Skynet
  String? nickname;

  FollowedUser(this.followerKey, this.userId);

  factory FollowedUser.fromJson(Map<String, dynamic> json) => _$FollowedUserFromJson(json);
  // : following = jsonDecode(json['following']),
  //   postArchive = jsonDecode(json['postArchive']),
  //   encryptionKey = json['encryptionKey'];
  factory FollowedUser.fromFriendFile(String friendFile) {
    List<String> splitFriendCode = friendFile.split(" ");
    return FollowedUser(splitFriendCode[0], splitFriendCode[1]);
  }

  Map<String, dynamic> toJson() => _$FollowedUserToJson(this);
}
