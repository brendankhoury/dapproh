// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicFeed _$PublicFeedFromJson(Map<String, dynamic> json) => PublicFeed(
      (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
    )
      ..profilePicture = json['profilePicture'] as String?
      ..profilePictureKeyAndIv = json['profilePictureKeyAndIv'] as String?;

Map<String, dynamic> _$PublicFeedToJson(PublicFeed instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'name': instance.name,
      'profilePicture': instance.profilePicture,
      'profilePictureKeyAndIv': instance.profilePictureKeyAndIv,
    };
