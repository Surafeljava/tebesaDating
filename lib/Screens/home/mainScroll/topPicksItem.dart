import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/likes/userProfileView.dart';
import 'package:dating/Screens/home/mainScroll/singleUserView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class TopPicksItem extends StatelessWidget {

  final UserModel userModel;

  TopPicksItem({this.userModel});

  @override
  Widget build(BuildContext context) {
    return SpringButton(
      SpringButtonType.OnlyScale,
      Stack(
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                    image: NetworkImage(userModel.photos[0]),
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

          Container(
            margin: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 70.0,
                  child: Stack(
                    children: [
                      Container(
                        height: 60.0,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.only(top: 8.0, left: 10.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14.0), bottomRight: Radius.circular(14.0)),
                        ),
                        child: Column(
                          children: [
                            Text('${userModel.fullName}', overflow: TextOverflow.ellipsis ,maxLines: 1, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey[800], letterSpacing: 0.5),),
                            Text('${userModel.bio}', overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[700], letterSpacing: 0.0),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 30.0,
                            height: 30.0,
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(1,2),
                                      blurRadius: 4.0
                                  ),
                                ]
                            ),
                            child: Icon(Icons.favorite, color: Colors.pinkAccent, size: 18.0,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserProfileView(userModel: userModel)));
      },

    );
  }
}
