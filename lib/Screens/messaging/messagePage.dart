import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Screens/messaging/messagesDisplay.dart';
import 'package:dating/Services/authService.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {

  final String convoRef;
  final String fullName;
  final String url;
  final String lastSeenTime;


  MessagePage({
    @required this.convoRef,
    @required this.fullName,
    @required this.url,
    @required this.lastSeenTime
  });

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  TextEditingController _messageTextController = new TextEditingController();
  String message = '';

  DatabaseService _databaseService = new DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFD12043), size: 30.0,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              child: Container(),
              backgroundImage: NetworkImage(widget.url),
            ),
            SizedBox(width: 10.0,),
            Container(
              width: MediaQuery.of(context).size.width/3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.fullName, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 0.6,), overflow: TextOverflow.ellipsis,),
                  Text(widget.lastSeenTime, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Colors.grey[600], letterSpacing: 0.3), overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[800],),
            color: Colors.white,
            onPressed: (){
              print('More');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 5.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.doc(widget.convoRef).collection('conversation').orderBy('time', descending: true).snapshots(),
                builder: (context, snapshot) {
                  return MessagesDisplay(snapshot: snapshot,);
                }
              ),
            ),

            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.image, color: Colors.grey[300],),
                  onPressed: (){

                  },
                ),
                Expanded(child: textBoxWidget(_messageTextController)),
                message.length != 0 ? IconButton(
                  icon: Icon(Icons.send, color: message.length == 0 ? Colors.grey[600] : Colors.blue,),
                  onPressed: () async{
                    if(message!='') {
                      //Remove the focus of the keyboard
                      FocusScope.of(context).unfocus();

                      String msg = message;

                      setState(() {
                        _messageTextController.text = '';
                        message = '';
                      });

                      //Send the message
                      await _databaseService.sendMessage(msg, '', 'text', widget.convoRef);
                    }
                    else{
                      print('Write Something First');
                    }
                  },
                ) : SizedBox(width: 5.0,),

              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget textBoxWidget(TextEditingController controller){
    return TextFormField(
      autofocus: false,
      validator: (val) => val.isEmpty ? 'Empty Field' : null,
      controller: controller,
      style: TextStyle(
        fontSize: 17.0,
        color: Colors.grey[800],
        letterSpacing: 0.5,
      ),
      onChanged: (val){
        setState(() {
          message = val;
        });
      },
      onTap: (){
        //TODO: on tap event
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
        hintText: 'Message',
        hintStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey[500],
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.grey[500], width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.grey[500], width: 2.0),
        ),
      ),
    );
  }
}
