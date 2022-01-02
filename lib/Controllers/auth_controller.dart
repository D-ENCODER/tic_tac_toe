import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tic_tac_toe/Utils/random_generator.dart';
import 'package:tic_tac_toe/Utils/storage.dart';

class AuthController {
  final Storage _storage = Storage();
  final RandomGenerator _random = RandomGenerator();

  Future<void> registerWithEmailAndPassword(Map credential) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: credential['email'], password: credential['password']);
      final User user = FirebaseAuth.instance.currentUser;
      final usersRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      usersRef.set({
        'name': credential['name'],
        'nickname': credential['nickname'],
        'email': user.email,
        'win': 0,
        'lose': 0,
        'draw': 0,
        'coin': 500,
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DatabaseReference usersRef = FirebaseDatabase.instance
        .reference()
        .child('users/${userCredential.user.uid}');

    DataSnapshot snapshot = await usersRef.once();

    if (snapshot.value == null) {
      usersRef.set({
        'name': userCredential.user.displayName,
        'nickname':
            userCredential.user.displayName.substring(0, 5).toLowerCase() +
                _random.generateNumber(3).toString(),
        'email': userCredential.user.email,
        'win': 0,
        'lose': 0,
        'draw': 0,
        'coin': 500,
      });
    }

    await _storage.setUID(userCredential.user.uid);
    return true;
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      Map credentials) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: credentials['email'], password: credentials['password']);

      final User user = FirebaseAuth.instance.currentUser;
      if (!user.emailVerified) {
        return _authenticationFailure('User is not verified.');
      }

      await _storage.setUID(user.uid);
      return _authenticationSuccess();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<bool> isAuthenticated() async {
    return _storage.getUID() != null;
  }

  Future<void> logout() async {
    await _storage.clearUID();
  }

  Map<String, dynamic> _authenticationSuccess() {
    return {'isAuthenticated': true};
  }

  Map<String, dynamic> _authenticationFailure(String message) {
    return {'isAuthenticated': false, 'message': message};
  }
}
