import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:dating/Screens/registration/registrationDataState.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

class EditProfileDetails extends StatefulWidget {
  @override
  _EditProfileDetailsState createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {

  bool done = false;

  DatabaseService _databaseService = new DatabaseService();

  UserModel me;
  bool myInfoGot = false;

  TextEditingController emailController;
  TextEditingController fullNameController;
  TextEditingController bDateController;
  TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    // TODO: get my info and add them to the respective variables

    _databaseService.getMyInfo().then((value) {
      setState(() {
        me = value;
        myInfoGot = true;
      });
      emailController = new TextEditingController(text: me.email);
      fullNameController = new TextEditingController(text: me.fullName);
      bDateController = new TextEditingController(text: me.bDate);
      bioController = new TextEditingController(text: me.bio);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('Edit profile details', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 1.0),),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[800],),
            color: Colors.white,
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: 15.0,),
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
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
                hintText: 'Email',
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
                labelText: 'FullName',
                labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
                hintText: 'FullName',
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
                labelText: 'BirthDate',
                labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
                hintText: 'BirthDate',
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
                hintText: 'Bio',
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
                      color: Color(0xFFD12043),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Center(
                    child:
                    Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                useCache: false,
                onTap: () async{

                  //Update the userdata
                  //email, fullname, bDate and bio
                  String email = emailController.text.isEmpty ? me.email : emailController.text;
                  String fullName =fullNameController.text.isEmpty ? me.fullName : fullNameController.text;
                  String bDate = bDateController.text.isEmpty ? me.bDate : bDateController.text;
                  String bio = bioController.text.isEmpty ? me.bio : bioController.text;
                  await _databaseService.updateUserInfo( email , fullName, bDate , bio);

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
