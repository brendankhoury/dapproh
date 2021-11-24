import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  DateTime datePosted;
  String description;
  String postLink; // IPFS access data, for now an estuary link.
  String postKey;
  String posterPubKey;
  String posterName;
  Post(this.datePosted, this.description, this.postLink, this.postKey, this.posterPubKey, this.posterName);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  // : datePosted = json['datePosted'],
  //   description = json['description'],
  //   postLink = json['postLink'],
  //   postKey = json['postKey'],
  //   posterPubKey = json['posterPubKey'],
  //   posterName = json['posterName'];

  Map<String, dynamic> toJson() => _$PostToJson(this); //{
  //   'datePosted': jsonEncode(datePosted),
  //   'description': description,
  //   'postLink': postLink,
  //   'postKey': postKey,
  //   'posterPubKey': posterPubKey,
  //   'posterName': posterName
  // };
}
