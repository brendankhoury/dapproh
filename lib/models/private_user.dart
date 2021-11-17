import 'package:dapproh/models/followed_user.dart';
import 'package:dapproh/models/post.dart';

class PrivateUser {
  // map<skynetpublickey, user>. prevents the same user from being added twice
  Map<String, FollowedUser> following;

  List<Post> postArchive;
  String privateEncryptionKey; //For the public user;
  String publicEncryptionKey; //For the public user;
  PrivateUser(this.following, this.postArchive, this.privateEncryptionKey, this.publicEncryptionKey);

  /*
    @effects following, inserts user into following if the public key is not already in the map
    @param user, the user to be inserted into following
    @returns if the user was inserted or not
  */
  bool addUser(FollowedUser user) {
    if (following.containsKey(user.publicKey)) {
      return false;
    }
    following.putIfAbsent(user.publicKey, () => user);
    return true;
  }

  /*
    @effects following, updates  user into following if the public key is already there
    @param user, the user to be inserted into following
    @returns if the user was updated or not
  */
  bool updateUser(FollowedUser user) {
    if (!following.containsKey(user.publicKey)) {
      return false;
    }
    following.update(user.publicKey, (_) => user);
    return true;
  }

  void addPost(Post post) {
    postArchive.add(post);
  }
}
