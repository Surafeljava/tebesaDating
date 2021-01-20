import 'package:dating/Screens/messaging/messagePage.dart';
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
      child: messagesListChecked ? Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: 10,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return Material(
              child: InkWell(
                child: ListTile(
                  title: Text('User Name', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                  subtitle: Text('Last Message', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, letterSpacing: 0.2),),
                  leading: CircleAvatar(
                    child: Container(),
                    backgroundImage: AssetImage('assets/test/user1.jpg'),
                  ),
                  trailing: Text('7:00 PM', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, letterSpacing: 0.2, color: Colors.grey[500]),),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessagePage()));
                },
              ),
            );
          },
        ),
      ) :
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
