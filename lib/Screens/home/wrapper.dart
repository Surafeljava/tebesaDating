import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userAuthModel.dart' as  usr;
import 'package:dating/Screens/authenticate/authenticate.dart';
import 'package:dating/Screens/home/mainScroll/mainHome.dart';
import 'package:dating/Screens/loading/loginCheckLoading.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Screens/registration/registrationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool registeredBefore = false;

  bool userChecked = false;

  bool checkingUser = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<usr.User>(context);

    final int a = Provider.of<Registration>(context).getUserIn;

    if(user==null){
      return Authenticate();
    }else{

      checkUserInfo().then((value) {
        setState(() {
          registeredBefore = value;
        });
        setState(() {
          checkingUser = true;
        });
      });

      if((a==1 || registeredBefore) && checkingUser){
        return MainHome();
      }else if((a!=1 || registeredBefore) && !checkingUser){
        return LoginCheckLoading();
      }else{
        return RegistrationPage();
      }
    }
  }

  Future<String> _getUserPreference() async{
    final pref = await SharedPreferences.getInstance();
    final userPref = pref.getString('userUid');
    if(userPref==null){
      return '';
    }else{
      return userPref;
    }
  }

  Future<bool> checkUserInfo() async{
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser==null){
      setState(() {
        userChecked = true;
      });
      return false;
    }else{
      var result = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      setState(() {
        userChecked = true;
      });
      return result.exists;
    }
  }
}
