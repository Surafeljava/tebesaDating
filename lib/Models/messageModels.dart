import 'package:flutter/foundation.dart';

class MessageModel{

  String message;
  String from;
  String replyTo;
  DateTime time;
  String messageId;
  String type;

  MessageModel({
    @required this.message,
    @required this.from,
    @required this.replyTo,
    @required this.time,
    @required this.messageId,
    @required this.type,
  });

  factory MessageModel.fromJson(dynamic json){
    return MessageModel(
        message: json['message'],
        from: json['from'],
        replyTo: json['replyTo'],
        time: DateTime.fromMicrosecondsSinceEpoch(json['time'].microsecondsSinceEpoch),
        messageId: json['messageId'],
        type: json['type']==null ? 'text' : json['type']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'from': from,
        'replyTo': replyTo,
        'time': time,
        'messageId': messageId,
        'type': type
      };

}

///For the lastmessage to be displayed on the messagePage List
class LastMessageModel{

  String message;
  String from;
  bool read;
  DateTime time;

  LastMessageModel({this.message, this.from, this.read, this.time});

  factory LastMessageModel.fromJson(dynamic json){
    return LastMessageModel(
      message: json['message'],
      from: json['from'],
      read: json['read'],
      time: DateTime.fromMicrosecondsSinceEpoch(json['time'].microsecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'from': from,
        'read': read,
        'time': time
      };

}


class ConversationModel{

  String conversationId;
  LastMessageModel lastMessage;
  int messageCount;
  int unreadMessage;
  String woman;
  String man;
  DateTime lastUpdate;

  ConversationModel({
    @required this.conversationId,
    @required this.lastMessage,
    @required this.messageCount,
    @required this.unreadMessage,
    @required this.woman,
    @required this.man,
    @required this.lastUpdate,
  });

  factory ConversationModel.fromJson(dynamic json){
    return ConversationModel(
      conversationId: json['conversationId'],
      lastMessage: LastMessageModel.fromJson(json['lastMessage']),
      messageCount: json['messageCount'],
      unreadMessage: json['unreadMessage'],
      woman: json['woman'],
      man: json['woman'],
      lastUpdate: DateTime.fromMicrosecondsSinceEpoch(json['lastUpdate'].microsecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'conversationId': conversationId,
        'lastMessage': lastMessage.toJson(),
        'messageCount': messageCount,
        'unreadMessage': unreadMessage,
        'woman': woman,
        'man': man,
        'lastUpdate': lastUpdate
      };

}