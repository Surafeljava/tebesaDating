import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('F', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600, color: Colors.grey[600]),),
                      Text('Female', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: selected==0 ? Color(0xFFD12043) : Colors.grey[600]),),
                    ],
                  ),
                ),
                useCache: false,
                onTap: () {
                  setState(() {
                    selected = 0;
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
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('M', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600, color: Colors.grey[600]),),
                      Text('Male', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: selected==1 ? Color(0xFFD12043) : Colors.grey[600]),),
                    ],
                  ),
                ),
                useCache: false,
                onTap: () {
                  setState(() {
                    selected = 1;
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
                    color: done ? Colors.grey[200] : Color(0xFFD12043),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Center(
                  child:
                  Text(
                    'Continue',
                    style: TextStyle(color: done ? Colors.grey[800] : Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              useCache: false,
              onTap: () {

                //add to the main list

                Provider.of<RegistrationState>(context, listen: false).setRegistrationPage(2);

              },
            ),
          ),

        ],
      ),
    );
  }
}
