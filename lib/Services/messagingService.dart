import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class MessagingService {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey = 'AAAAmYXT1Ic:APA91bH_7UHIR3lElWPH6Rp2Ic_fTn2WxECNr6ZrOgjsHcU-ZBY3IscVFDrhduCC85jUzjnQS1rBnq5C-md1OBiqXFziP_MjdpyW_H-JE_STk8XSGiGYCv9CBlGInq9Ar_Svv7SbPl3R';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) => sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
      {@required String title,
        @required String body,
        @required String topic}) => sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) => client.post(
    'https://fcm.googleapis.com/fcm/send',
    body: json.encode({
      'notification': {'body': '$body', 'title': '$title'},
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      'to': '$fcmToken',
    }),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
  );
}