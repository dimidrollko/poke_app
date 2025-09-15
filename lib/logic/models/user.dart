import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isEmailVerified;

  const User({
    required this.uid,
    this.email,
    this.displayName,
    required this.isEmailVerified,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
