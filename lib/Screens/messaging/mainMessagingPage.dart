import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/messageModels.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/messaging/messagePage.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MainMessagingPage extends StatefulWidget {
  @override
  _MainMessagingPageState createState() => _MainMessagingPageState();
}

class _MainMessagingPageState extends State<MainMessagingPage> {
  List<dynamic> messagesList = [];
  bool messagesListChecked = false;

  DatabaseService _databaseService = new DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModel me;
  String genderMe = '';
  String genderToBeFound = '';

  int selectedConvoIndex = -1;
  bool deleteWaiting = false;

  @override
  void initState() {
    super.initState();

    _databaseService.getMyInfo().then((value) {
      if (value.gender.toLowerCase() == 'male') {
        setState(() {
          genderMe = 'man';
          genderToBeFound = 'woman';
        });
      } else {
        setState(() {
          genderMe = 'woman';
          genderToBeFound = 'man';
        });
      }
      setState(() {
        me = value;
      });
    });

    _databaseService.getMyMessagesList().then((value) {
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
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: messagesListChecked
            ? messagesList.length == 0
                ? Center(
                    child: Text(
                      'No Messages',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[500],
                          fontSize: 25.0,
                          letterSpacing: 1.0),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: messagesList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .doc(messagesList[index])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[200],
                                  highlightColor: Colors.grey[100],
                                  enabled: true,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 55.0,
                                        height: 55.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: 14.0,
                                              color: Colors.white,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                            ),
                                            Container(
                                              width: 100.0,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .doc(snapshot.data[genderToBeFound])
                                        .snapshots(),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.data == null) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        LastMessageModel lMessage =
                                            LastMessageModel.fromJson(
                                                snapshot.data['lastMessage']);
                                        String checkString =
                                            lMessage.message.split(":")[0];
                                        bool check = checkString == "https";
                                        return Material(
                                          child: InkWell(
                                            child: ListTile(
                                              title: Text(
                                                snapshot2.data['fullName'],
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.5),
                                              ),
                                              subtitle: Text(
                                                check
                                                    ? "File"
                                                    : lMessage.message,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w300,
                                                    letterSpacing: 0.2),
                                              ),
                                              leading: selectedConvoIndex ==
                                                      index
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.grey[800],
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          deleteWaiting = false;
                                                          selectedConvoIndex =
                                                              -1;
                                                        });
                                                      },
                                                    )
                                                  : CircleAvatar(
                                                      child: Container(),
                                                      backgroundImage:
                                                          NetworkImage(
                                                              snapshot2.data[
                                                                  'photos'][0]),
                                                    ),
                                              trailing: deleteWaiting
                                                  ? Container(
                                                      width: 25.0,
                                                      height: 25.0,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                        ),
                                                      ),
                                                    )
                                                  : selectedConvoIndex == index
                                                      ? IconButton(
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              deleteWaiting =
                                                                  true;
                                                            });

//                                    final snackBarRegistered = SnackBar(
//                                      content: Text('Delete'),
//                                      duration: Duration(minutes: 20),
//                                      action: SnackBarAction(
//                                        label: 'Yes',
//                                        textColor: Colors.amber,
//                                        onPressed: (){
//
//                                        },
//                                      ),
//                                    );
//                                    _scaffoldKey.currentState.showSnackBar(snackBarRegistered);

                                                            await _databaseService
                                                                .deleteConversation(
                                                                    messagesList[
                                                                        index]);

                                                            setState(() {
                                                              deleteWaiting =
                                                                  false;
                                                              selectedConvoIndex =
                                                                  -1;
                                                            });
                                                          },
                                                        )
                                                      : Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                      'h:mm a')
                                                                  .format(
                                                                      lMessage
                                                                          .time)
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  color: Colors
                                                                          .grey[
                                                                      500]),
                                                            ),
                                                            snapshot.data[
                                                                        'unreadMessage'] ==
                                                                    0
                                                                ? Container(
                                                                    height:
                                                                        10.0,
                                                                    width: 10.0,
                                                                  )
                                                                : lMessage.from ==
                                                                        me.uid
                                                                    ? Container(
                                                                        height:
                                                                            10.0,
                                                                        width:
                                                                            10.0,
                                                                      )
                                                                    : Text(
                                                                        '${snapshot.data['unreadMessage']}',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .redAccent,
                                                                            fontSize:
                                                                                18.0,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                          ],
                                                        ),
                                            ),
                                            onTap: () {
                                              if (lMessage.from != me.uid) {
                                                _databaseService
                                                    .updateUnreadMessage(
                                                        messagesList[index]);
                                              }
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          MessagePage(
                                                            convoRef:
                                                                messagesList[
                                                                    index],
                                                            fullName:
                                                                snapshot2.data[
                                                                    'fullName'],
                                                            url: snapshot2.data[
                                                                'photos'][0],
                                                            lastSeenTime:
                                                                DateFormat(
                                                                        'h:mm a')
                                                                    .format(
                                                                        lMessage
                                                                            .time)
                                                                    .toString(),
                                                          )));
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                selectedConvoIndex = index;
                                              });
                                            },
                                          ),
                                        );
                                      }
                                    });
                              }
                            });
                      },
                    ),
                  )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[200],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 55.0,
                                  height: 55.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 14.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                      ),
                                      Container(
                                        width: 100.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
