import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/options/editProfileDetails.dart';
import 'package:dating/Screens/home/options/updatePhotos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('Profile Edit', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 1.0),),
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width-20,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.doc('users/${FirebaseAuth.instance.currentUser.uid.toString()}').snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.data==null){
                    return ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return Container(
                          width: 185.0,
                          height: 185.0,
                          margin: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[400]
                          ),
                        );
                      },
                    );
                  }else{
                    UserModel user = UserModel.fromJson(snapshot.data);
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: user.photos.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        return Container(
                          width: 185.0,
                          height: 185.0,
                          margin: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(user.photos[index]),
                              fit: BoxFit.cover
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              ),
            ),
            SizedBox(height: 20.0,),
            SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                width: MediaQuery.of(context).size.width/1.5,
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Center(
                  child:
                  Text(
                    'Update Photos',
                    style: TextStyle(color: Colors.grey[800], fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              useCache: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdatePhotos()));
              },
            ),

            SizedBox(height: 20.0,),

            SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                width: MediaQuery.of(context).size.width/1.5,
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Center(
                  child:
                  Text(
                    'Update Details',
                    style: TextStyle(color: Colors.grey[800], fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              useCache: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileDetails()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
