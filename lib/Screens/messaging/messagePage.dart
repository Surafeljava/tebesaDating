import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  TextEditingController _messageTextController = new TextEditingController();
  String message = '';

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
              backgroundImage: AssetImage('assets/test/user1.jpg'),
            ),
            SizedBox(width: 10.0,),
            Container(
              width: MediaQuery.of(context).size.width/3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Name', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 0.6,), overflow: TextOverflow.ellipsis,),
                  Text('8:42 PM', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Colors.grey[600], letterSpacing: 0.3), overflow: TextOverflow.ellipsis,),
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
              child: Container(
                padding: EdgeInsets.all(10.0),

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
                      FocusScope.of(context).unfocus();

                      String msg = message;

//                      await MessagingService.sendToTopic(title: (me.firstName + ' ' + me.lastName), body: msg, topic: widget.documentSnapshot['conversationId']);
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
