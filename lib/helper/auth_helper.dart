import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();
  static FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  final GoogleSignIn SignInG = GoogleSignIn();
  final FirebaseAuth authentication = FirebaseAuth.instance;

  Future<User?> logInAnonymously() async {
    UserCredential userCred = await authentication.signInAnonymously();

    User? myUser = userCred.user;
    return myUser;
  }

  Future<User?> signUpUser(
      {required String email, required String password}) async {
    UserCredential userCred = await authentication
        .createUserWithEmailAndPassword(email: email, password: password);
    User? myUser = userCred.user;
    return myUser;
  }

  Future<User?> signInUser(
      {required String email, required String password}) async {
    UserCredential userCred = await authentication.signInWithEmailAndPassword(
        email: email, password: password);
    User? myUser = userCred.user;
    return myUser;
  }

  Future<User?> singInWithGoogle() async {
    final GoogleSignInAccount? user2 = await SignInG.signIn();

    final GoogleSignInAuthentication? googleAuth = await user2?.authentication;

    final cred = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );

    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(cred);
    return userCred.user;
  }

  singOutUser() async {
    await SignInG.signOut();
    await authentication.signOut();
  }

  Future<void> EditedEmail({required String email}) async {
    User? myUser = authentication.currentUser;

    return await myUser!.updateEmail("$email");
  }

  Future<void> EditedName({required String name}) async {
    User? myUser = authentication.currentUser;

    return await myUser!.updateDisplayName("$name");
  }

  Future<void> EditedPass({required String password}) async {
    User? myUser = authentication.currentUser;

    return await myUser!.updatePassword("$password");
  }
}
