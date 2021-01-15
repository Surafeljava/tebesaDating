import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:dating/Screens/registration/addPhotos.dart';
import 'package:dating/Screens/registration/genderChoose.dart';
import 'package:dating/Screens/registration/profileDetails.dart';
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
    return WillPopScope(
      onWillPop: (){
        Provider.of<RegistrationState>(context, listen: false).setRegistrationPage(0);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFD12043),),
            onPressed: (){
              Provider.of<RegistrationState>(context, listen: false).setRegistrationPage(0);
            },
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: getThePage(Provider.of<RegistrationState>(context).getRegistrationPage),
        ),
      ),
    );
  }

  Widget getThePage(int val){
    if(val==0){
      return GenderChoose();
    }else if(val==1){
      return ProfileDetails();
    }else{
      return AddPhotos();
    }
  }
}
