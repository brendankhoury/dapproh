import 'package:dapproh/models/followed_user.dart';
import 'package:dapproh/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'private_user.g.dart';

@JsonSerializable()
class PrivateUser {
  // map<skynetpublickey, user>. prevents the same user from being added twice
  Map<String, FollowedUser> following;

  List<Post> postArchive;
  String encryptionKey; //For the public user;
  PrivateUser(this.following, this.postArchive, this.encryptionKey);

  /*
    @effects following, inserts user into following if the public key is not already in the map
    @param user, the user to be inserted into following
    @returns if the user was inserted or not
  */
  bool addUser(FollowedUser user) {
    if (following.containsKey(user.userId)) {
      return false;
    }
    following.putIfAbsent(user.userId, () => user);
    return true;
  }

  /*
    @effects following, updates  user into following if the public key is already there
    @param user, the user to be inserted into following
    @returns if the user was updated or not
  */
  bool updateUser(FollowedUser user) {
    if (!following.containsKey(user.userId)) {
      return false;
    }
    following.update(user.userId, (_) => user);
    return true;
  }

  void addPost(Post post) {
    postArchive.add(post);
  }

  factory PrivateUser.fromJson(Map<String, dynamic> json) => _$PrivateUserFromJson(json);
  // : following = jsonDecode(json['following']),
  //   postArchive = jsonDecode(json['postArchive']),
  //   encryptionKey = json['encryptionKey'];

  Map<String, dynamic> toJson() => _$PrivateUserToJson(this); // {'following': following, 'postArchive': postArchive, 'encryptionKey': encryptionKey};
}
