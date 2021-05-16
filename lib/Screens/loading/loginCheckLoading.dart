import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginCheckLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Loading...', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30.0, letterSpacing: 1.0),),
            SizedBox(height: 20.0,),
            Lottie.asset(
              'assets/lottie/loading.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
          ],
        )
      ),
    );
  }
}
