import 'package:dating/Screens/home/mainScroll/topPicksItem.dart';
import 'package:flutter/material.dart';

class TopPicks extends StatefulWidget {
  @override
  _TopPicksState createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              crossAxisCount: 2,
              childAspectRatio: 0.9
          ),
          itemBuilder: (_, index) {
            return TopPicksItem();
          },
          itemCount:9,
        ),
      ),
    );
  }
}
