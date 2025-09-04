import 'package:poke_app/logic/repositories/auth/user_raw_model.dart';

abstract class IAuthRepository {
  Stream<UserRawModel?> authStateChanges();

  Future<void> signInWith(String email, String password);
  Future<void> signUpWith(String email, String password);

  Future<void> logout();
}
