import 'package:dating/Services/authService.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthService _authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey[800]),),
            color: Colors.orange,
            onPressed: (){
              _authService.signInAnon();
            },
          ),
          RaisedButton(
            child: Text('Log Out', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey[800]),),
            color: Colors.white,
            onPressed: (){
              _authService.signOut();
            },
          ),
        ],
      )
    );
  }
}
