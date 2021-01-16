import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';

class MainMessagingPage extends StatefulWidget {
  @override
  _MainMessagingPageState createState() => _MainMessagingPageState();
}

class _MainMessagingPageState extends State<MainMessagingPage> {

  List<dynamic> messagesList = [];
  bool messagesListChecked = false;

  DatabaseService _databaseService = new DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseService.getMyMessagesList().then((value){
      setState(() {
        messagesList = value;
      });
      setState(() {
        messagesListChecked = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: messagesListChecked ? ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(''),
          );
        },
      ) :
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
