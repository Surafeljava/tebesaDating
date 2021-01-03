import 'package:dating/Screens/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Registration Page'),
          SizedBox(height: 20.0,),
          RaisedButton(
            child: Text('Register', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),),
            color: Colors.pinkAccent,
            onPressed: (){
              Provider.of<Registration>(context, listen: false).setUserIn(1);
            },
          ),
        ],
      ),
    );
  }
}
