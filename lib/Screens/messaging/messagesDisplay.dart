import 'package:flutter/material.dart';

class MessagesDisplay extends StatefulWidget {
  @override
  _MessagesDisplayState createState() => _MessagesDisplayState();
}

class _MessagesDisplayState extends State<MessagesDisplay> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,

    );
  }
}
