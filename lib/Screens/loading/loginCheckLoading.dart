import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginCheckLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading...', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),),
            SizedBox(height: 15.0,),
            SpinKitChasingDots(
              color: Color(0xFFD12043),
              size: 40.0,
            ),
          ],
        )
      ),
    );
  }
}
