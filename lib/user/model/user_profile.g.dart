// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  username: json['username'] as String,
  email: json['email'] as String,
  discoveredEntities:
      (json['discovered_entities'] as List<dynamic>)
          .map((e) => Discovered.fromJson(e as Map<String, dynamic>))
          .toList(),
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'discovered_entities': instance.discoveredEntities,
      'avatar': instance.avatar,
    };
