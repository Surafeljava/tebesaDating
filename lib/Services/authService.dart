import 'package:dating/Models/userAuthModel.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService{
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  //From Firebase User to User
  User _fromFirebaseUserToUser(auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //Auth Change User Stream
  Stream<User> get user {
    return _auth.authStateChanges().map(_fromFirebaseUserToUser);
  }

  //Anon Sign in
  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      auth.User user = result.user;
      return _fromFirebaseUserToUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  //Sign in with Cred
  Future signIn(auth.AuthCredential credential) async {
    try {
      var result = await _auth.signInWithCredential(credential);
      auth.User user = result.user;
      return _fromFirebaseUserToUser(user);
    } catch (e) {
      print('************ The Error: ${e.toString()} :************');
      return null;
    }
  }

  //Currently Logged in user
  Future<String> getCurrentUser() async{
    return (_auth.currentUser).uid;
  }

  //Signin with OTP
  signInWithOTP(smsCode, verId){
    print('************ WITH OTP Function ************');
    auth.AuthCredential authCreds = auth.PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

}
