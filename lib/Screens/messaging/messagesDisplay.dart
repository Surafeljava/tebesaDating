import 'package:bubble/bubble.dart';
import 'package:dating/Models/messageModels.dart';
import 'package:dating/Models/userAuthModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MessagesDisplay extends StatefulWidget {

  final AsyncSnapshot snapshot;

  MessagesDisplay({
    @required this.snapshot
  });

  @override
  _MessagesDisplayState createState() => _MessagesDisplayState();
}

class _MessagesDisplayState extends State<MessagesDisplay> {
  @override
  Widget build(BuildContext context) {
    if(widget.snapshot.data==null){
      return Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }else{
      return ListView.builder(
        itemCount: widget.snapshot.data.documents.length,
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index){
          MessageModel message = MessageModel.fromJson(widget.snapshot.data.documents[index]);
          int sendFrom;
          if(message.from == Provider.of<User>(context, listen: false).uid){
            sendFrom = 0;
          }else{
            sendFrom = 1;
          }
          return messageItem(sendFrom, message, index);
        },
      );
    }
  }


  Widget messageItem(int who, MessageModel message, int index){
    Color messageTwoBg = Colors.grey[300];
    Color messageOneBg = Colors.pinkAccent;
    Color messageOneText = Colors.white;
    Color messageTwoText = Colors.grey[900];
    return Column(
      children: <Widget>[
        SizedBox(height: 5.0,),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: Column(
              children: <Widget>[

                Bubble(
                  child: message.type=='image' ?
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            message.message,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.zoom_out_map, color: Colors.white,),
                              onPressed: (){

                              },
                            ),
                            backgroundColor: Colors.black54,

                          ),
                        ),
                      ],
                    ),
                  ) :
                  Text(message.message, style: TextStyle(color: who==1 ? messageTwoText : messageOneText, fontWeight: FontWeight.w400, fontSize: 14)),
                  nip: who == 1 && message.type!='image' ?  BubbleNip.leftBottom : who == 0 && message.type!='image' ? BubbleNip.rightBottom : BubbleNip.no,
                  padding: message.type=='image' ? BubbleEdges.all(0) : BubbleEdges.all(10),
                  alignment: who == 1 ?  Alignment.centerLeft : Alignment.centerRight,
                  color:  who == 1 ?  messageTwoBg : messageOneBg,
                  radius: Radius.circular(10.0),
                  margin: BubbleEdges.only(left: 5.0, right: 5.0),
                  elevation: 0.0,
                ),
                SizedBox(height: 5.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: who == 1 ?  MainAxisAlignment.start : MainAxisAlignment.end,
                    children: <Widget>[
                      Text(DateFormat('h:mm a').format(message.time).toString(), style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10.0),),
                    ],
                  ),
                ),
              ],
            ),
            onTap: (){

            },
            onDoubleTap: (){

            },
            onLongPress: (){

            },
          ),
        ),


        SizedBox(height: 5.0,),

      ],
    );
  }
}
