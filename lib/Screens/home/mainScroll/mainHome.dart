import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {

  AuthService _authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, color: Colors.grey[800]),),
          color: Colors.orange,
          onPressed: (){
            _authService.signOut();
            Provider.of<Registration>(context, listen: false).setUserIn(0);
          },
        ),
      ),
    );
  }
}
