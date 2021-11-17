class FollowedUser {
  String feedLocation;
  String followerKey; // Used to decrypt the feed
  String publicKey; // Used to find the feed on Skynet
  // String nickname;
  FollowedUser(this.feedLocation, this.followerKey, this.publicKey);
}
