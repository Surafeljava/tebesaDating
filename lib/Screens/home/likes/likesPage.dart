import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/likesModel.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/likes/userProfileView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LikesPage extends StatefulWidget {
  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid.toString()).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.data==null){
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 55.0,
                              height: 55.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 14.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                  Container(
                                    width: 100.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }else{
          if(snapshot.data['likes'].length == 0){
            return Center(
              child: Text('No Likes', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[500], fontSize: 25.0, letterSpacing: 1.0),),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data['likes'].length,
            itemBuilder: (context, index){
              LikesModel like = LikesModel.fromJson(snapshot.data['likes'][index]);
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.doc(like.like).snapshots(),
                  builder: (context, snapshot2) {
                    if(snapshot2.data==null){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else{
                      UserModel userModel = UserModel.fromJson(snapshot2.data);
                      return Material(
                        child: InkWell(
                          child: ListTile(
                            title: Text(userModel.fullName, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                            subtitle: Text('Bio: ${userModel.bio}', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, letterSpacing: 0.2),),
                            leading: CircleAvatar(
                              child: Container(),
                              backgroundImage: NetworkImage(snapshot2.data['photos'][0]),
                            ),
                            trailing: Icon(Icons.favorite, color: Colors.pinkAccent, size: 18.0,)
                          ),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserProfileView(userModel: userModel)));
                          },
                        ),
                      );
                    }
                  }
              );
            },
          );
        }
      }
    );
  }

}
