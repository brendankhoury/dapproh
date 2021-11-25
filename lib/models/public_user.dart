import 'package:dapproh/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_user.g.dart';

@JsonSerializable()
class PublicFeed {
  List<Post> posts;
  String name;

  PublicFeed(this.posts, this.name);

  factory PublicFeed.fromJson(Map<String, dynamic> json) => _$PublicFeedFromJson(json);
  // : datePosted = json['datePosted'],
  //   description = json['description'],
  //   postLink = json['postLink'],
  //   postKey = json['postKey'],
  //   posterPubKey = json['posterPubKey'],
  //   posterName = json['posterName'];

  Map<String, dynamic> toJson() => _$PublicFeedToJson(this);

  void addPost(Post post) {
    posts.add(post);
  }
}
