import 'package:firebase_auth/firebase_auth.dart';
import 'package:poke_app/logic/repositories/auth/iauth_repository.dart';
import 'package:poke_app/logic/repositories/auth/user_raw_model.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<UserRawModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserRawModel(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    });
  }

  @override
  Future<void> logout() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> signInWith(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUpWith(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
