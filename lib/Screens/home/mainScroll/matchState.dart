import 'package:flutter/foundation.dart';

class MatchState with ChangeNotifier{

  bool match = false;

  bool get getMatchState => match;

  void setMatchState(bool state){
    match = state;
    notifyListeners();
  }

}