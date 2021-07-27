import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/messageModels.dart';
import 'package:dating/Screens/messaging/messagesDisplay.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class MessagePage extends StatefulWidget {
  final String convoRef;
  final String fullName;
  final String url;
  final String lastSeenTime;

  MessagePage(
      {@required this.convoRef,
      @required this.fullName,
      @required this.url,
      @required this.lastSeenTime});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _messageTextController = new TextEditingController();
  String message = '';

  DatabaseService _databaseService = new DatabaseService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool val = false;

  bool recording = false;

  int recordState = 0;

  bool audioPermission = false;

  bool sendingAudio = false;

  String currentRecordedUrl = '';
  String currentRecordedTime = '';

  bool reply = false;
  String replyTo = '';

  // ignore: deprecated_member_use
  FlutterSound recorder = new FlutterSound();

  @override
  void initState() {
    super.initState();

    Permission.microphone.status.then((value) {
      print('***** Permission: ${value.toString()} *****');
    });
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void addReply(String toWhat) {
    setState(() {
      reply = true;
      replyTo = toWhat;
    });
  }

  void removeReply() {
    setState(() {
      reply = false;
      replyTo = '';
    });
  }

  void deleteMessage(MessageModel model) async {
    await _databaseService.deleteMessage(widget.convoRef, model.messageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFFD12043),
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              child: Container(),
              backgroundImage: NetworkImage(widget.url),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fullName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[800],
                      letterSpacing: 0.6,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.lastSeenTime,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        letterSpacing: 0.3),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 5.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .doc(widget.convoRef)
                      .collection('conversation')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return MessagesDisplay(
                      snapshot: snapshot,
                      onReply: addReply,
                      onDelete: deleteMessage,
                    );
                  }),
            ),

            //TODO: reply finish
            reply
                ? Container(
                    height: 40.0,
                    color: Colors.grey[100],
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text('Reply to:'),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                            child: Text(
                          '$replyTo',
                          style: TextStyle(color: Colors.grey[500]),
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[800],
                          ),
                          onPressed: removeReply,
                        )
                      ],
                    ))
                : Container(),

            recordState != 0
                ? Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 25.0,
                          ),
                          onPressed: () {
                            setState(() {
                              recordState = 0;
                            });
                          },
                        ),
                        recordState == 1
                            ? IconButton(
                                icon: Icon(
                                  Icons.stop,
                                  color: Colors.grey[800],
                                  size: 25.0,
                                ),
                                //Stopping the Audio recording here *****************
                                onPressed: () async {
                                  String stopResult =
                                      await recorder.stopRecorder();

                                  setState(() {
                                    recordState = 2;
                                  });
                                },
                              )
                            : Container(),
                        Spacer(),
                        recordState != 2
                            ? Lottie.asset(
                                'assets/lottie/recording.json',
                                width: 60,
                                height: 25,
                                fit: BoxFit.fill,
                              )
                            : Container(),
                        Text(recordState != 2
                            ? 'Recording...'
                            : 'Stopped $currentRecordedTime'),
                        Spacer(),
                        recordState == 2
                            ? IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                  size: 25.0,
                                ),
                                //Sending the Audio recording here *****************
                                onPressed: () async {
                                  setState(() {
                                    recordState = 0;
                                    sendingAudio = true;
                                  });

                                  File audio = File('$currentRecordedUrl');
                                  String myUid = FirebaseAuth
                                      .instance.currentUser.uid
                                      .toString();
                                  String audioName =
                                      myUid + DateTime.now().toString();
                                  String uploadedAudioPath =
                                      await _databaseService.uploadAudio(
                                          audio, audioName);

                                  await _databaseService.sendMessage(
                                      uploadedAudioPath,
                                      replyTo,
                                      'audio',
                                      widget.convoRef);
                                  removeReply();
                                  setState(() {
                                    sendingAudio = false;
                                  });
                                },
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Row(
                    children: <Widget>[
                      sendingAudio
                          ? Lottie.asset(
                              'assets/lottie/recording.json',
                              width: 40,
                              height: 25,
                              fit: BoxFit.fill,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.settings_voice,
                                color:
                                    recording ? Colors.green : Colors.grey[800],
                              ),
                              //Starting the Audio recording here *****************
                              onPressed: () async {
                                setState(() {
                                  recordState = 1;
                                });

                                String result = await recorder.startRecorder();

                                setState(() {
                                  currentRecordedUrl = result;
                                  currentRecordedTime = 'Recorded';
                                });
                                print('****** Result: $result');
                              },
                            ),
                      Expanded(child: textBoxWidget(_messageTextController)),
                      message.length != 0
                          ? IconButton(
                              icon: Icon(
                                Icons.send,
                                color: message.length == 0
                                    ? Colors.grey[600]
                                    : Colors.blue,
                              ),
                              onPressed: () async {
                                if (message != '') {
                                  //Remove the focus of the keyboard
                                  FocusScope.of(context).unfocus();

                                  String msg = message;

                                  setState(() {
                                    _messageTextController.text = '';
                                    message = '';
                                  });

                                  //Send the message
                                  await _databaseService.sendMessage(
                                      msg, replyTo, 'text', widget.convoRef);
                                  removeReply();
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text("No Text"),
                                    duration: Duration(milliseconds: 1000),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              },
                            )
                          : SizedBox(
                              width: 5.0,
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget textBoxWidget(TextEditingController controller) {
    return TextFormField(
      autofocus: false,
      validator: (val) => val.isEmpty ? 'Empty Field' : null,
      controller: controller,
      style: TextStyle(
        fontSize: 17.0,
        color: Colors.grey[800],
        letterSpacing: 0.5,
      ),
      onChanged: (val) {
        setState(() {
          message = val;
        });
      },
      onTap: () {
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
          borderSide: BorderSide(color: Colors.grey[500], width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey[500], width: 2.0),
        ),
      ),
    );
  }
}
