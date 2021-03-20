import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentApprovalWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('Tebesa Dating',style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 1.0),),
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/loading.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Your payment confirmation detail is being assessed!', textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey[700], letterSpacing: 0.6),
              ),
            ),
            SizedBox(height: 10.0,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'The approval process might take 1 business day.', textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.grey[700], letterSpacing: 0.6),
              ),
            ),

            Spacer(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Come back later', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300, color: Colors.grey[700], letterSpacing: 0.6),
              ),
            ),

            SizedBox(height: 30.0,),
          ],
        ),
      )
    );
  }
}
