
///For the main message model
class MessageModel{

  String message;
  String from;
  String replyTo;
  DateTime time;
  String messageId;
  String type;

  MessageModel({this.message, this.from, this.replyTo, this.time, this.messageId, this.type});

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