import 'dart:io';

import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:dating/Screens/registration/registrationDataState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

class GenderChoose extends StatefulWidget {
  @override
  _GenderChooseState createState() => _GenderChooseState();
}

class _GenderChooseState extends State<GenderChoose> {

  List<String> interestedIn = [ 'Female', 'Male', 'Both'];

  String interest = 'Female';

  int selected = -1;

  String gender = '';

  bool done = false;

  final String manIcon = 'assets/icons/man.svg';
  final String womanIcon = 'assets/icons/woman.svg';


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.white,
      child: ListView(
        children: [
          Text('Select your \ngender', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, letterSpacing: 0.0, color: Colors.grey[800]),),
          SizedBox(height: 25.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  width: (MediaQuery.of(context).size.width-50)/2,
                  height: (MediaQuery.of(context).size.width-50)/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        womanIcon,
                        width: 50.0,
                        height: 50.0,
                        color: selected==0 ? Color(0xFFD12043) : Colors.grey[600],
                      ),
                      SizedBox(height: 10.0,),
                      Text('Female', style: TextStyle(fontSize: 20, fontWeight: selected==0 ? FontWeight.w600 : FontWeight.w400, color: selected==0 ? Color(0xFFD12043) : Colors.grey[600]),),
                    ],
                  ),
                ),
                useCache: false,
                onTap: () {
                  setState(() {
                    selected = 0;
                    gender = 'Female';
                    interest = 'Male';
                    done = true;
                  });
                },
              ),


              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  width: (MediaQuery.of(context).size.width-50)/2,
                  height: (MediaQuery.of(context).size.width-50)/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        manIcon,
                        width: 50.0,
                        height: 50.0,
                        color: selected==1 ? Color(0xFFD12043) : Colors.grey[600],
                      ),
                      SizedBox(height: 10.0,),
                      Text('Male', style: TextStyle(fontSize: 20, fontWeight: selected==1 ? FontWeight.w600 : FontWeight.w400, color: selected==1 ? Color(0xFFD12043) : Colors.grey[600]),),
                    ],
                  ),
                ),
                useCache: false,
                onTap: () {
                  setState(() {
                    selected = 1;
                    gender = 'Male';
                    interest = 'Female';
                    done = true;
                  });
                },
              ),

            ],
          ),

          SizedBox(height: 35.0,),

          Text('I am interested in', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0, letterSpacing: 0.0, color: Colors.grey[800]),),

          SizedBox(height: 5.0,),

          Container(
            child: DropdownButton(
              hint: Text(interest),
              elevation: 0,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 1.0, color: Colors.grey[800]),
              icon: Icon(Icons.keyboard_arrow_down),
              underline: Container(
                color: Colors.white,
              ),
              items: interestedIn.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              )).toList(),
              onChanged: (item){
                print(item);
                setState(() {
                  interest = item;
                });
              },
            ),
          ),

          SizedBox(height: 15.0,),

          Center(
            child: SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                width: MediaQuery.of(context).size.width/1.2,
                height: 50.0,
                decoration: BoxDecoration(
                    color: !done ? Colors.grey[200] : Color(0xFFD12043),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Center(
                  child:
                  Text(
                    'Continue',
                    style: TextStyle(color: !done ? Colors.grey[800] : Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              useCache: false,
              onTap: () {

                //add to the main list
                if(done){

                  Provider.of<RegistrationDataState>(context, listen: false).AddPageOneData(gender, interest);
                  Provider.of<RegistrationState>(context, listen: false).setRegistrationPage(1);
                }

              },
            ),
          ),

        ],
      ),
    );
  }
}
