import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/authenticate/authenticate.dart';
import 'package:dating/Screens/home/mainScroll/mainHome.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Screens/registration/registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    final int a = Provider.of<Registration>(context).getUserIn;

    if(user==null){
      return Authenticate();
    }else{
      if(a==0){
        return RegistrationPage();
      }else{
        return MainHome();
      }
    }
  }
}
