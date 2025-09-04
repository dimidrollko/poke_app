import 'package:poke_app/logic/repositories/auth/user_raw_model.dart';

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
  
  static User fromRaw(UserRawModel rawModel) {
    return User(
      isEmailVerified: rawModel.isEmailVerified,
      uid: rawModel.uid,
      displayName: rawModel.displayName,
      email: rawModel.email,
    );
  }
}
