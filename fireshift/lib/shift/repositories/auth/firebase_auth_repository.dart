import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireshift/shift/entities/auth.dart';
import 'package:fireshift/shift/repositories/auth/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  @override
  Future initialize() {
    return Future.value();
  }

  @override
  Future<Either<AppUser, Error>> authenticate(
      String login, String password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: login,
      password: password,
    );

    return Left<AppUser, Error>(_userFromFirebase(userCredential.user));
  }

  AppUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(
        uid: user.uid, email: user.email, displayName: user.displayName);
  }
}
