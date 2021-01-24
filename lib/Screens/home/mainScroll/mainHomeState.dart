import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MainHomeState with ChangeNotifier{

  PageController mainHomePageController = new PageController();

  PageController get getMainHomePageController => mainHomePageController;

  void changeMainHomePage(){
    mainHomePageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }


  int page = 0;

  int get getPage => page;

  void resetPage(){
    page = 0;
    notifyListeners();
  }

  void changePage(bool front){
    if(front){
      page += 1;
    }else{
      if(page > 0){
        page -= 1;
      }else{
        page = 0;
      }
    }
    notifyListeners();
  }

}