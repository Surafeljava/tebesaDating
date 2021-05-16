import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CheckingFreeDate extends StatelessWidget {

  final bool freeTrial;

  CheckingFreeDate({this.freeTrial});

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

              freeTrial ? Lottie.asset(
                'assets/lottie/paid.json',
                width: 350,
                height: 200,
                fit: BoxFit.contain,
              ): Lottie.asset(
                'assets/lottie/loading.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 30.0,),

              Text(freeTrial ? 'Enjoy your free package!' :'Free package Checking...',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25.0, letterSpacing: 0.5, color: freeTrial? Colors.green : Colors.grey[800]),
              ),

            ],
          )
      ),
    );
  }
}