import 'package:dating/Screens/video_call_screen/widgets/end_call_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "Calling...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
              letterSpacing: 3.0,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Surafel Kindu",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Lottie.asset(
            'assets/lottie/video-call.json',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          Spacer(),
          EndCallButton(),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
