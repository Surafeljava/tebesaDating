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

  UserModel me;
  String genderMe = '';
  String genderToBeFound = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _databaseService.getMyInfo().then((value) {
      if(value.gender.toLowerCase()=='male'){
        setState(() {
          genderMe = 'man';
          genderToBeFound = 'woman';
        });
      }else{
        setState(() {
          genderMe = 'woman';
          genderToBeFound = 'man';
        });
      }
      setState(() {
        me = value;
      });
    });

    _databaseService.getMyMessagesList().then((value){
      setState(() {
        messagesList = value;
        print('********************* $value');
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
          itemCount: messagesList.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return StreamBuilder(
              stream: FirebaseFirestore.instance.doc(messagesList[index]).snapshots(),
              builder: (context, snapshot) {

                if(snapshot.data==null){
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[100],
                    enabled: true,
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
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 14.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
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
                }else{
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.doc(snapshot.data[genderToBeFound]).snapshots(),
                    builder: (context, snapshot2) {
                      if(snapshot2.data==null){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }else{
                        LastMessageModel lMessage = LastMessageModel.fromJson(snapshot.data['lastMessage']);
                        return Material(
                          child: InkWell(
                            child: ListTile(
                              title: Text(snapshot2.data['fullName'], style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                              subtitle: Text(lMessage.message, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, letterSpacing: 0.2),),
                              leading: CircleAvatar(
                                child: Container(),
                                backgroundImage: NetworkImage(snapshot2.data['photos'][0]),
                              ),
                              trailing: Text(DateFormat('h:mm a').format(lMessage.time).toString(), style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, letterSpacing: 0.2, color: Colors.grey[500]),),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) => MessagePage(convoRef: messagesList[index], fullName: snapshot2.data['fullName'], url: snapshot2.data['photos'][0], lastSeenTime: DateFormat('h:mm a').format(lMessage.time).toString(),)));
                            },
                          ),
                        );
                      }
                    }
                  );
                }


              }
            );
          },
        ),
      ) :
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 14.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
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
    );
  }
}
