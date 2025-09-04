// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserRawModel {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isEmailVerified;

  UserRawModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.isEmailVerified,
  });
}
