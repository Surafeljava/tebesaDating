import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:dating/Screens/registration/registrationDataState.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {

  bool done = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController bDateController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.white,
      child: ListView(
        children: [
          Text('My profile \ndetails', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, letterSpacing: 0.0, color: Colors.grey[800]),),
          SizedBox(height: 25.0,),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            style: TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.0,
                color: Colors.black
            ),
            decoration: InputDecoration(
              labelText: 'My email address',
              labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
              hintText: 'example@abc.com',
              hintStyle: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                  color: Colors.grey[700]
              ),
            ),
          ),

          SizedBox(height: 15.0,),

          TextField(
            autofocus: true,
            keyboardType: TextInputType.name,
            style: TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.0,
                color: Colors.black
            ),
            controller: fullNameController,
            decoration: InputDecoration(
              labelText: 'My full name',
              labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
              hintText: 'Joe Scot',
              hintStyle: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                  color: Colors.grey[700]
              ),
            ),
          ),

          SizedBox(height: 15.0,),

          TextField(
            inputFormatters: [
              MultiMaskedTextInputFormatter(
                  masks: ['xx/xx/xxxx',], separator: '/')
            ],
            autofocus: true,
            keyboardType: TextInputType.number,
            controller: bDateController,
            style: TextStyle(
              fontSize: 18.0,
              letterSpacing: 1.0,
              color: Colors.black
            ),
            decoration: InputDecoration(
              labelText: 'My birthday(optional)',
              labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
              hintText: 'DD/MM/YYYY',
              hintStyle: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                  color: Colors.grey[700]
              ),
            ),
          ),

          TextField(
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.0,
                color: Colors.black
            ),
            maxLines: 3,
            minLines: 2,
            controller: bioController,
            decoration: InputDecoration(
              labelText: 'Bio',
              labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
              hintText: 'About you',
              hintStyle: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                  color: Colors.grey[700]
              ),
            ),
          ),

          SizedBox(height: 20.0,),

          Center(
            child: SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                width: MediaQuery.of(context).size.width-30,
                height: 50.0,
                decoration: BoxDecoration(
                    color: emailController.text.isEmpty || fullNameController.text.isEmpty || bDateController.text.isEmpty || bioController.text.isEmpty ? Colors.grey[200] : Color(0xFFD12043),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Center(
                  child:
                  Text(
                    'Continue',
                    style: TextStyle(color: emailController.text.isEmpty || fullNameController.text.isEmpty || bDateController.text.isEmpty || bioController.text.isEmpty ? Colors.grey[800] : Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              useCache: false,
              onTap: () {

                //add to the main list
                Provider.of<RegistrationDataState>(context, listen: false).AddPageTwoData(emailController.text, fullNameController.text, bDateController.text, bioController.text);

                Provider.of<RegistrationState>(context, listen: false).setRegistrationPage(2);

              },
            ),
          ),
        ],
      ),
    );
  }
}
