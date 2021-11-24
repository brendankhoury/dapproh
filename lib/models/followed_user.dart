import 'package:json_annotation/json_annotation.dart';
part 'followed_user.g.dart';

@JsonSerializable()
class FollowedUser {
  String feedLocation;
  String followerKey; // Used to decrypt the feed
  String publicKey; // Used to find the feed on Skynet
  // String nickname;
  FollowedUser(this.feedLocation, this.followerKey, this.publicKey);

  factory FollowedUser.fromJson(Map<String, dynamic> json) => _$FollowedUserFromJson(json);
  // : following = jsonDecode(json['following']),
  //   postArchive = jsonDecode(json['postArchive']),
  //   encryptionKey = json['encryptionKey'];

  Map<String, dynamic> toJson() => _$FollowedUserToJson(this);
}
