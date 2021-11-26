// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      DateTime.parse(json['datePosted'] as String),
      json['description'] as String,
      json['postLink'] as String,
      json['postKey'] as String,
      json['postIv'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'datePosted': instance.datePosted.toIso8601String(),
      'description': instance.description,
      'postLink': instance.postLink,
      'postKey': instance.postKey,
      'postIv': instance.postIv,
    };
