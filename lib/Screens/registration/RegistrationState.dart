import 'package:flutter/foundation.dart';

class RegistrationState with ChangeNotifier{

  int registrationPageCount = 0;

  int get getRegistrationPage => registrationPageCount;

  void setRegistrationPage(int page){
    registrationPageCount = page;
    notifyListeners();
  }

}