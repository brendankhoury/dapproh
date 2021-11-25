// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowedUser _$FollowedUserFromJson(Map<String, dynamic> json) => FollowedUser(
      json['followerKey'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$FollowedUserToJson(FollowedUser instance) =>
    <String, dynamic>{
      'followerKey': instance.followerKey,
      'userId': instance.userId,
    };
