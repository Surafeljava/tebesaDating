import 'dart:async';

import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/singleUserView.dart';
import 'package:dating/Screens/home/mainScroll/topPicksItem.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';

class TopPicks extends StatefulWidget {
  @override
  _TopPicksState createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {

  List<UserModel> dates = [];

  DatabaseService _databaseService = new DatabaseService();

  List<UserModel> topPickedUsers = [];

  bool gettingTopPics = true;

  @override
  void initState() {
    super.initState();
    _databaseService.getTopPicksList().then((value){
      setState(() {
        topPickedUsers = value;
        gettingTopPics = false;
      });
    });
  }

  BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gettingTopPics ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 15.0,
              crossAxisCount: 2,
              childAspectRatio: 0.8
          ),
          itemBuilder: (_, index) {
            return TopPicksItem(userModel: topPickedUsers[index],);
          },
          itemCount:topPickedUsers.length,
        ),
      ),
    );
  }
}
