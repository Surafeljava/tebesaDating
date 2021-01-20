import 'package:dating/Models/userModel.dart';
import 'package:flutter/foundation.dart';

class DatesState with ChangeNotifier{

  List<UserModel> userModels = [];

  List<UserModel> get getMyDates => userModels;

  void addNewDates(List<UserModel> models){
    print('******** ${models.length}');
    userModels = models;
    notifyListeners();
  }

}