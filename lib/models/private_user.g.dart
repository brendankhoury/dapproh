// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateUser _$PrivateUserFromJson(Map<String, dynamic> json) => PrivateUser(
      (json['following'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, FollowedUser.fromJson(e as Map<String, dynamic>)),
      ),
      (json['postArchive'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['encryptionKey'] as String,
    );

Map<String, dynamic> _$PrivateUserToJson(PrivateUser instance) =>
    <String, dynamic>{
      'following': instance.following,
      'postArchive': instance.postArchive,
      'encryptionKey': instance.encryptionKey,
    };
