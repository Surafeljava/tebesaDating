import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotifyAnimations extends StatefulWidget {

  final int animationType;
  NotifyAnimations({this.animationType});

  @override
  _NotifyAnimationsState createState() => _NotifyAnimationsState();
}

class _NotifyAnimationsState extends State<NotifyAnimations> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<String> animations = ['assets/lottie/love.json'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(animations[widget.animationType]),
    );
  }
}
