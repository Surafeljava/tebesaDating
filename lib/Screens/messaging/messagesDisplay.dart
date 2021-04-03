import 'package:bubble/bubble.dart';
import 'package:dating/Models/messageModels.dart';
import 'package:dating/Models/userAuthModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spring_button/spring_button.dart';

class MessagesDisplay extends StatefulWidget {

  final AsyncSnapshot snapshot;
  final Function onReply;
  final Function onDelete;

  MessagesDisplay({
    @required this.snapshot,
    @required this.onReply,
    @required this.onDelete,
  });

  @override
  _MessagesDisplayState createState() => _MessagesDisplayState();
}

class _MessagesDisplayState extends State<MessagesDisplay> {

  int audioPlayingIndex = -1;
  int loadingAudioIndex = -1;

  int currentSelectedIndex = -1;
  MessageModel currentSelectedMessage;

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
      return Stack(
        children: [
          ListView.builder(
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
          ),
          currentSelectedIndex!=-1 ? Container(
            color: Colors.black12,
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text('Delete',),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.redAccent,
                    ),
                    onPressed: () async{
                      //TODO: Delete here
                      MessageModel model = currentSelectedMessage;
                      _optionsClicked(-1, null);
                      await widget.onDelete(model);
                    },
                  ),
                  SizedBox(width: 15.0,),
                  TextButton.icon(
                    icon: Icon(Icons.replay),
                    label: Text('Reply',),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.grey[800],
                    ),
                    onPressed: (){
                      if(currentSelectedMessage.type=='text'){
                        widget.onReply(currentSelectedMessage.message);
                      }else{
                        widget.onReply('File');
                      }
                      _optionsClicked(-1, null);
                    },
                  ),
                  SizedBox(width: 15.0,),
                  TextButton.icon(
                    icon: Icon(Icons.close),
                    label: Text('Close',),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.grey[800],
                    ),
                    onPressed: (){
                      _optionsClicked(-1, null);
                    },
                  ),
                ],
              )
            ),
          ) : Container(),
        ],
      );
    }
  }

  formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void _playing(int index){
    setState(() {
      audioPlayingIndex = index;
    });
  }

  void _loading(int index){
    setState(() {
      loadingAudioIndex = index;
    });
  }

  void _optionsClicked(int index, MessageModel messageModel){
    setState(() {
      currentSelectedIndex = index;
      currentSelectedMessage = messageModel;
    });
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
          color: currentSelectedIndex==index ? Colors.grey[300] : Colors.transparent,
          child: InkWell(
            child: Column(
              children: <Widget>[

                message.replyTo.isNotEmpty ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: who == 1 ?  MainAxisAlignment.start : MainAxisAlignment.end,
                    children: <Widget>[
                      Text('To:', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),),
                      SizedBox(width: 5.0,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text('${message.replyTo}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),),
                      ),
                    ],
                  ),
                ) : Container(),
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
                  ) : message.type == 'audio' ? Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        index==audioPlayingIndex ? Lottie.asset(
                          'assets/lottie/recording.json',
                          width: 60,
                          height: 25,
                          fit: BoxFit.fill,
                        ) : Container(),
                        Text(index==audioPlayingIndex ? 'Playing...' : index==loadingAudioIndex ? 'Loading' : 'Audio Message', style: TextStyle(color: who==1 ? messageTwoText : messageOneText),),
                        SizedBox(width: 10.0,),
                        index==audioPlayingIndex ? Container() : index==loadingAudioIndex ? Container(
                          width: 20.0,
                          height: 20.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(who==1 ? messageTwoText : messageOneText),
                              strokeWidth: 1.5,
                            ),
                          ),
                        ): SpringButton(
                          SpringButtonType.OnlyScale,
                          Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(Icons.play_arrow, color: Colors.grey[800]),
                            ),
                          ),
                          onTap: () async{
                            _loading(index);
                            final player = AudioPlayer();
                            await player.setUrl(message.message);
                            await player.setVolume(1.0);
                            _playing(index);
                            await player.play();
                            _playing(-1);
                            _loading(-1);
                          },
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
              if(message.type=='text'){
                widget.onReply(message.message);
              }else{
                widget.onReply('File');
              }
            },
            onLongPress: (){
              _optionsClicked(index, message);
            },
          ),
        ),


        SizedBox(height: 5.0,),

      ],
    );
  }
}
