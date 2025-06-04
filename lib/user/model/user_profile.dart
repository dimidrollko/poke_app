// models/user_profile.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:poke_app/user/model/discovered.dart';
part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String username;
  final String email;
  @JsonKey(name: 'discovered_entities')
  final List<Discovered> discoveredEntities;
  final String? avatar;

  UserProfile({
    required this.username,
    required this.email,
    required this.discoveredEntities,
    this.avatar,
  });
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
