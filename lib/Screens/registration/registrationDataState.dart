import 'package:dating/Models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RegistrationDataState with ChangeNotifier{

  String gender = '';
  String interest = '';

  String email = '';
  String fullName = '';
  String bDate = '';
  String bio = '';

  List<String> photos = [];

  void AddPageOneData(String gd, String ints){
    gender = gd;
    interest = ints;
    notifyListeners();
  }

  void AddPageTwoData(String eml, String fNm, String bD, String bo){
    email = eml;
    fullName = fNm;
    bDate = bD;
    bio = bo;
    notifyListeners();
  }

  void AddPageThreeData(List<String> phts){
    photos = phts;
    notifyListeners();
  }

  UserModel get getRegistrationData => UserModel(uid: FirebaseAuth.instance.currentUser.uid, email: email, fullName: fullName, bDate: bDate, gender: gender, interest: interest, photos: photos, bio: bio);

}