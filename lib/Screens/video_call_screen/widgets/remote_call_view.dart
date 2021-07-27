import 'package:flutter/material.dart';

class RemoteCallView extends StatefulWidget {
  const RemoteCallView({Key key}) : super(key: key);

  @override
  _RemoteCallViewState createState() => _RemoteCallViewState();
}

class _RemoteCallViewState extends State<RemoteCallView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text('Video Call'),
      ),
    );
  }
}
