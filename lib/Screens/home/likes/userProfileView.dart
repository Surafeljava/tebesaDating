import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/singleUserView.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatelessWidget {

  final UserModel userModel;

  UserProfileView({@required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.pinkAccent
        ),
        title: Text('Profile View', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 1.0),),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleUserView(userModel: userModel, fromHome: false,),
    );
  }
}
