import 'package:dating/Screens/authenticate/sign_in.dart';
import 'package:dating/Services/authService.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  AuthService _authService = new AuthService();

  int signIn = 0;

  @override
  Widget build(BuildContext context) {
    return signIn==0 ? Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Sign In (Anon)', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey[800]),),
              color: Colors.orange,
              onPressed: (){
                setState(() {
                  signIn = 1;
                });
              },
            ),
            RaisedButton(
              child: Text('Sign in with Google', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.grey[800]),),
              color: Colors.grey[100],
              onPressed: (){
                _authService.signInAnon();
              },
            ),
            RaisedButton(
              child: Text('Sign in with Phone', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),),
              color: Colors.pinkAccent,
              onPressed: (){
                _authService.signInAnon();
              },
            ),
          ],
        ),
      )
    ) : SignIn();
  }
}
