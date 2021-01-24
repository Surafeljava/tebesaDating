import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/matchState.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchView extends StatelessWidget {

  final UserModel otherUser;
  final UserModel me;

  MatchView({@required this.otherUser, @required this.me});

  final DatabaseService databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Spacer(),
                    createCircularPic(this.otherUser.photos[0]),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.favorite, color: Colors.pinkAccent, size: 40.0,),
                    ),
                    createCircularPic(this.me.photos[0]),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 20.0,),
                Text("It's a Match", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),),
                SizedBox(height: 10.0,),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text("You and ${this.otherUser.fullName} like each other, \n you can now chat", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: <Widget>[
                    Spacer(),
                    RaisedButton(
                      child: Text('Chat Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.pinkAccent,
                      onPressed: () async{

                        //Create new conversation
                        await databaseService.createConversation(me, otherUser);

                        //send notification (both about the match and the conversation creation)
                        //TODO: send notifications

                        Provider.of<MatchState>(context, listen: false).setMatchState(false);

                      },
                    ),
                    SizedBox(width: 20.0,),
                    RaisedButton(
                      child: Text('Keep Browsing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.black,
                      onPressed: () async{

                        //Add to matches for both users
                        await databaseService.updateMatch(me, otherUser);

                        //send notification (about the match)
                        //TODO: send notifications


                        Provider.of<MatchState>(context, listen: false).setMatchState(false);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createCircularPic(String imgUrl){
    return Container(
      width: 83.0,
      height: 83.0,
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pinkAccent,
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
