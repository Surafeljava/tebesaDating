import 'package:flutter/foundation.dart';

class Registration with ChangeNotifier{

  int userIn = 0;

  int get getUserIn => userIn;

  void setUserIn(int uin){
    userIn = uin;
    notifyListeners();
  }

}