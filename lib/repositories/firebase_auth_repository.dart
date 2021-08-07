import 'package:assistant/util/error/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User getUser() => _auth.currentUser;

  Future<UserCredential> createAccount(String email, String password) async {
    assert(email != null && email.isNotEmpty);
    assert(password != null && password.isNotEmpty);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Weak password') {
        throw WeakPassword(e.code);
      } else if (e.code == 'Email already in use') {
        throw EmailAlreadyInUse(e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> login(String email, String password) async {
    assert(email != null && email.isNotEmpty);
    assert(password != null && password.isNotEmpty);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFound('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw WrongPassword('Wrong password provided for that user.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
