import 'package:flutter/foundation.dart';

class AuthState with ChangeNotifier{

  static int signInMethod = 0;

  int get getUserIn => signInMethod;

  void setUserIn(int method){
    signInMethod = method;
    notifyListeners();
  }

}