import 'package:flutter/material.dart';

class EndCallButton extends StatelessWidget {
  const EndCallButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
