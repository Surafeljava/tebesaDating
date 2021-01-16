import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MainHomeState with ChangeNotifier{

  PageController mainHomePageController = new PageController();

  PageController get getMainHomePageController => mainHomePageController;

  void changeMainHomePage(){
    mainHomePageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

}