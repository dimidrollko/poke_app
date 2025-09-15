// models/user_profile.dart
import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String username;
  final String email;
  final String? avatar;

  Profile({
    required this.username,
    required this.email,
    this.avatar,
  });
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
