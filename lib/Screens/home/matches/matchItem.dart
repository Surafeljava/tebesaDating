import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class MatchItem extends StatelessWidget {

  final UserModel otherUser;

  MatchItem({@required this.otherUser});

  DatabaseService _databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: EdgeInsets.only(bottom: 0.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                      image: NetworkImage(otherUser.photos[0]),
                      fit: BoxFit.cover
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1,2),
                      blurRadius: 5.0,
                    ),
                  ]
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 60.0,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(1,2),
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(otherUser.fullName, overflow: TextOverflow.ellipsis ,maxLines: 1, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500, color: Colors.grey[800], letterSpacing: 0.5),),
                    Text(otherUser.bio, overflow: TextOverflow.ellipsis ,maxLines: 1, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.grey[600], letterSpacing: 0.0),),
                  ],
                ),
              ),
              SizedBox(height: 5.0,),
              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  height: 40.0,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFD12043),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1,2),
                          blurRadius: 5.0,
                        ),
                      ]
                  ),
                  child: Center(
                    child: Text('Chat Now', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.0),),
                  ),
                ),
                onTap: (){
                  _databaseService.removeMatches(FirebaseFirestore.instance.collection('users').doc('${otherUser.uid}').path.toString());
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}
