// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowedUser _$FollowedUserFromJson(Map<String, dynamic> json) => FollowedUser(
      json['feedLocation'] as String,
      json['followerKey'] as String,
      json['publicKey'] as String,
    );

Map<String, dynamic> _$FollowedUserToJson(FollowedUser instance) =>
    <String, dynamic>{
      'feedLocation': instance.feedLocation,
      'followerKey': instance.followerKey,
      'publicKey': instance.publicKey,
    };
