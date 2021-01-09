import 'package:dating/Models/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class LocationService{


  Future<String> getCountryPhoneCode(String code) async{
    List<Country> countries = await _convertJsonToModels();
    for(var i=0; i<countries.length; i++){
      if(countries[i].code == code){
        return countries[i].dialCode;
      }
    }
  }

  Future<List<Country>> _convertJsonToModels() async{

    String arrayObjsText = await rootBundle.loadString('assets/country_code.json');

    var countryObjsJson = jsonDecode(arrayObjsText) as List;
    List<Country> countryObj = countryObjsJson.map((countryJson) => Country.fromJson(countryJson)).toList();
    return countryObj;
  }

}