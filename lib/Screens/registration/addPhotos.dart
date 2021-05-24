import 'dart:io';

import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Screens/registration/registrationDataState.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

class AddPhotos extends StatefulWidget {
  @override
  _AddPhotosState createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {

  List<File> photos = [];

  String photoIcon = 'assets/icons/photo2.svg';
  String plusIcon = 'assets/icons/plus.svg';

  bool done = false;
  bool uploading = false;

  int clickedIndex = -1;

  bool photoClicked = false;

  File _image;
  final picker = ImagePicker();

  DatabaseService _databaseService = new DatabaseService();

  Future<bool> getImage(ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);

    setState(() {
      if (pickedFile != null) {
        if(photos.length>clickedIndex){
          photos[clickedIndex] = File(pickedFile.path);
        }else{
          photos.add(File(pickedFile.path));
        }
        return true;
      } else {
        print('No image selected.');
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          color: Colors.white,
          child: ListView(
            children: [
              Text('Add photos', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, letterSpacing: 0.0, color: Colors.grey[800]),),
              SizedBox(height: 5.0,),
              Text('Upload or take pictures', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: 0.0, color: Colors.grey[800]),),
              SizedBox(height: 25.0,),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width*1.2,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                    crossAxisCount: 3,
                    childAspectRatio: 0.9
                  ),
                  itemBuilder: (_, index) {
                    return SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        decoration: BoxDecoration(
                          color: index > photos.length ? Colors.white : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: photos.length>=index+1 ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(photos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ) : Center(
                          child: index == photos.length ? SvgPicture.asset(
                            plusIcon,
                            width: 25.0,
                            height: 25.0,
                            color: Colors.grey[300],
                          ) : Container(),
                        ),
                      ),
                      useCache: false,
                      onTap: () {
                        if(index<=photos.length){
                          setState(() {
                            photoClicked = true;
                            clickedIndex = index;
                          });
                        }
                      },
                    );
                  },
                  itemCount:9,
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
                        color: photos.length==0 ? Colors.grey[200] : Color(0xFFD12043),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Center(
                      child:
                      Text(
                        'Done',
                        style: TextStyle(color: photos.length==0 ? Colors.grey[800] : Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  useCache: false,
                  onTap: () async{

                    if(photos.isNotEmpty){
                      setState(() {
                        uploading = true;
                      });

                      //add to the main list
                      List<String> pics = [];
                      pics = await uploadUserPictures();

                      Provider.of<RegistrationDataState>(context, listen: false).AddPageThreeData(pics);

                      UserModel user = Provider.of<RegistrationDataState>(context, listen: false).getRegistrationData;

                      String uid = FirebaseAuth.instance.currentUser.uid.toString();

                      await _databaseService.addNewUser(user, uid);

                      setState(() {
                        uploading = false;
                      });

                      Provider.of<Registration>(context, listen: false).setUserIn(1);
                      Provider.of<RegistrationState>(context, listen: false).setRegistrationPage(0);
                    }else{
                      print('Add Pictures First');
                    }

                  },
                ),
              ),


            ],
          ),
        ),

        photoClicked && !uploading ? Container(
          color: Colors.black26,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width/1.5,
              height: MediaQuery.of(context).size.width/1.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  FlatButton(
                    child: Icon(Icons.close, color: Colors.redAccent,),
                    onPressed: (){
                      setState(() {
                        photoClicked = false;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),

                  Center(
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        width: (MediaQuery.of(context).size.width/1.5)-30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child:
                          Text(
                            'Camera',
                            style: TextStyle(color: Colors.grey[800], fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      useCache: false,
                      onTap: () async{
                        getImage(ImageSource.camera).then((value){
                          print('Image get Result: $value');
                        });
                        setState(() {
                          photoClicked = false;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 10.0,),

                  Center(
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        width: (MediaQuery.of(context).size.width/1.5)-30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child:
                          Text(
                            'Gallery',
                            style: TextStyle(color: Colors.grey[800], fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      useCache: false,
                      onTap: () {
                        getImage(ImageSource.gallery).then((value){
                          print('Image get Result: $value');
                        });
                        setState(() {
                          photoClicked = false;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 10.0,),

                  clickedIndex<photos.length ? Center(
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        width: (MediaQuery.of(context).size.width/1.5)-30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Color(0xFFD12043),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child:
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      useCache: false,
                      onTap: () {
                        setState(() {
                          photos.removeAt(clickedIndex);
                          photoClicked = false;
                        });
                      },
                    ),
                  ) :
                  Container(),

                ],
              ),
            ),
          ),
        ) : !photoClicked && uploading ?
        Container(
          color: Colors.black12,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width/1.6,
              height: MediaQuery.of(context).size.width/1.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('uploading...', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, letterSpacing: 0.0, color: Colors.grey[800]),),
                  SizedBox(height: 15.0,),
                  SpinKitFadingCircle(
                    color: Color(0xFFD12043),
                    size: 40.0,
                  ),
                ],
              ),
            ),
          ),
        ) : Container(),
      ],
    );
  }


  Future<List<String>> uploadUserPictures() async{
    List<String> uploadedPicture = [];
    for(File pic in photos){
      String name = FirebaseAuth.instance.currentUser.uid.toString() + photos.indexOf(pic).toString();
      String url = await _databaseService.uploadProfileImage(pic, name);
      print('******* Add Photos (url) ******* $url');
      uploadedPicture.add(url);
    }

    print('******* Add Photos (photos list) ******* $uploadedPicture');
    return uploadedPicture;
  }

}
