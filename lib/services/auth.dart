import 'package:chatting_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final auth = FirebaseAuth.instance;

  Users? _user(User user) {
    return user != null ? Users(user.uid) : null;
  }

  signin(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _user(userCredential.user!);
    } catch (e) {
      print(e);
    }
  }

  signup(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _user(userCredential.user!);
    } catch (e) {
      print(e);
    }
  }

  resetpassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  signout() async {
    await auth.signOut();
  }
}
