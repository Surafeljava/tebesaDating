import 'dart:async';

import 'package:dating/Models/userModel.dart';
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

  @override
  void initState() {
    super.initState();
    // TODO: get the topPick dates
    Timer.periodic(Duration(seconds: 3), (timer) {
      _databaseService.getTopPicksList().then((value){
        setState(() {
          topPickedUsers = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            return TopPicksItem();
          },
          itemCount:topPickedUsers.length,
        ),
      ),
    );
  }
}
