import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/likesModel.dart';
import 'package:dating/Models/messageModels.dart';
import 'package:dating/Models/paymentModel.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/datesState.dart';
import 'package:dating/Services/messagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbStore;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:dating/Models/lastSeenModel.dart';

import 'package:mailer/mailer.dart';

class DatabaseService with ChangeNotifier{

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference paymentCollection = FirebaseFirestore.instance.collection('paymentRequests');
  final CollectionReference conversationCollection = FirebaseFirestore.instance.collection('conversations');

  final MessagingService _messagingService = new MessagingService();

  Future<void> checkRegistered() async{
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var result = await firestoreInstance.collection('users').doc(firebaseUser.uid).get();
    return UserModel.fromJson(result);
  }

  Future<String> uploadProfileImage(File image, String name) async {

    fbStore.Reference ref = fbStore.FirebaseStorage.instance.ref('userImages/$name');
    fbStore.TaskSnapshot uploadTask = await ref.putFile(image);

    final String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;

  }

  ///Create new user account by adding the registration information to the database
  Future<void> addNewUser(UserModel _userModel, String _uid) async {
    await userCollection.doc(_uid).set(_userModel.toJson());
    await addNewUserAdditionalData();
  }

  Future<void> updateUserInfo(String email, String fullName, String bDate, String bio) async{
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    await userCollection.doc(uid).update({'email': email, 'fullName': fullName, 'bDate': bDate, 'bio': bio});
  }

  ///Add users additional information like: last seen, messages, likes and matches
  Future<void> addNewUserAdditionalData() async{
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    await userCollection.doc(uid).update({'lastSeen':[], 'messages':[], 'likes':[], 'matches':[]});
  }

  ///Get my information
  Future<UserModel> getMyInfo() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return UserModel.fromJson(result);
  }


  ///Get my payment info
  Future<PaymentModel> getMyPaymentInfo() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('paymentRequests').doc(_uid).get();
    return PaymentModel.fromJson(result);
  }


  ///Send new payment request created email
  Future<void> sendNewRequestEmail(PaymentModel paymentModel) async{
    String username = 'tikusevents.info@gmail.com';
    String password = 'm^5Xg<AkZ(bH7)D}';

    Map<String, String> banks = {"CBE":"1000145305717", "Hibret Bank":"1000145305717", "Dashen Bank":"1000145305717", "Wegagen Bank":"1000145305717"};

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Tebesa Dating')
      ..recipients.add(paymentModel.email)
      ..subject = 'Tebesa Payment Request'
      ..html = "<h1>Payment Invoice</h1>\n<p>Invoice Number: ${paymentModel.invoice}</p>"
          "<p>Request Date: <Strong>${paymentModel.date.day}/${paymentModel.date.month}/${paymentModel.date.year}</Strong></p>"
          "<p>Package Months: <Strong>${paymentModel.packageMonth} months</Strong></p>"
          "<p>Bank: <Strong>${paymentModel.bank}</Strong></p>"
          "<p>Account Number: <Strong>${banks["${paymentModel.bank}"]}</Strong></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

  }

  ///Create new payment
  Future<void> createNewPayment(PaymentModel paymentModel) async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    print(paymentModel.toJson());
    await paymentCollection.doc(_uid).set(paymentModel.toJson());
    await sendNewRequestEmail(paymentModel);
  }


  ///Update payment status * adding confirmation number *
  Future<void> updatePayment({String transactionRef, String depositedByName}) async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    await paymentCollection.doc(_uid).update({'transactionRef': transactionRef, 'confirmed': true, 'depositedByName': depositedByName, 'status': 0});
  }


  ///Get All my photos
  Future<List<dynamic>> getMyPhotos() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    UserModel me = UserModel.fromJson(result);
    return me.photos;
  }

  ///Upload audio
  Future<String> uploadAudio(File audio, String name) async {
    fbStore.Reference ref = fbStore.FirebaseStorage.instance.ref('userAudio/$name');
    fbStore.TaskSnapshot uploadTask = await ref.putFile(audio);

    final String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  ///Upload one photo
  Future<String> uploadOnePhoto(File image, String name) async {
    fbStore.Reference ref = fbStore.FirebaseStorage.instance.ref('userImages/$name');
    fbStore.TaskSnapshot uploadTask = await ref.putFile(image);

    final String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  ///Update photos
  Future<void> updatePhotos(List<dynamic> photosList) async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    await firestoreInstance.collection('users').doc(_uid).update({'photos': photosList});
  }

  ///Get my likes
  Future<List<dynamic>> getMyLikes()async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return result['likes'];
  }

  ///Update the dates list
  Future<void> getNewDates(BuildContext context) async{

    List<UserModel> myDates = [];
    int myLastSeenDates = 0;
    List<dynamic> lastSeenDatesList = [];
    List<String> lastSeenDates = [];

    UserModel me = await getMyInfo();

    var result1 = await firestoreInstance.collection('users').doc(me.uid).get();
    lastSeenDatesList = result1['lastSeen'];

    var result = await firestoreInstance.collection('users').where('gender', isEqualTo: me.interest).get();

    for(dynamic last in lastSeenDatesList){
      LastSeenModel lastModel = LastSeenModel.fromJson(last);
      String lastUid = lastModel.like.split('/')[1].toString();
      lastSeenDates.add(lastUid);
    }

    result.docs.forEach((element) {
      if(!lastSeenDates.contains(UserModel.fromJson(element).uid)){
        myDates.add(UserModel.fromJson(element));
      }
    });


    result.docs.forEach((element) {
      if(lastSeenDates.contains(UserModel.fromJson(element).uid)){
        myDates.add(UserModel.fromJson(element));
        myLastSeenDates += 1;
      }
    });

    Provider.of<DatesState>(context, listen: false).addNewDates(myDates);

  }


  ///Get my last seen dates
  Future<List<dynamic>> getMyLastSeenDates() async{
    List<dynamic> lastSeenDatesList = [];
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result1 = await firestoreInstance.collection('users').doc(uid).get();
    lastSeenDatesList = result1['lastSeen'];

    return lastSeenDatesList;
  }

  ///For MainMessagingPage and Deleting Account
  Future<List<dynamic>> getMyMessagesList() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return result['messages'];
  }

  ///Get all my matches information
  Future<List<dynamic>> getMyMatches() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return result['matches'];
  }

  ///Function to be called on disLike button clicked
  Future<bool> updateOnDisLikes(String otherUid) async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var ref = firestoreInstance.collection('users').doc('$_uid');
    var refOther = firestoreInstance.collection('users').doc('$otherUid');

    LikesModel lastSeenModel = LikesModel(type: 0, like: refOther.path.toString(), date: DateTime.now());

    //update my lastSeen list
    ref.update({'lastSeen' : FieldValue.arrayUnion([lastSeenModel.toJson()])});
    return true;
  }

  ///Function to be called on like button clicked
  Future<bool> updateOnLikes(int type, String otherUid) async {
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var ref = firestoreInstance.collection('users').doc('$_uid');
    var refOther = firestoreInstance.collection('users').doc('$otherUid');

    LikesModel like2 = LikesModel(type: type, like: refOther.path.toString(), date: DateTime.now());
    LikesModel like = LikesModel(type: type, like: ref.path.toString(), date: DateTime.now());

    //update my lastSeen list
    ref.update({'lastSeen' : FieldValue.arrayUnion([like2.toJson()])});


    //update otherUsers liked list
    refOther.update({'likes': FieldValue.arrayUnion([like.toJson()])});

    //send notification
    MessagingService.sendToTopic(title: 'Likes', body: 'Someone liked you', topic: '${otherUid}_like');

    return true;

  }

  ///adding users to the match
  Future<bool> updateMatch(UserModel me, UserModel other) async{

    var meRef = firestoreInstance.collection('users').doc('${me.uid}');
    var otherRef = firestoreInstance.collection('users').doc('${other.uid}');

    //Add to their matches list (both)
    meRef.update({'matches' : FieldValue.arrayUnion([otherRef.path.toString()])});
    otherRef.update({'matches' : FieldValue.arrayUnion([meRef.path.toString()])});

    //Send New Match notification
    MessagingService.sendToTopic(title: 'You have a new match 🥂', body: 'click to see who your match is', topic: '${me.uid}_match');

    return true;

  }

  ///Remove matches from their respective list on creating conversation
  Future<bool> removeMatches(String otherReference) async{
    //Prepare my reference
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(uid).get();
    final String myRef = firestoreInstance.collection('users').doc(uid).path.toString();
    final UserModel myModel = UserModel.fromJson(result);

    //Get other user model
    var result2 = await firestoreInstance.doc(otherReference).get();
    final UserModel otherModel = UserModel.fromJson(result2);

    //Create the conversation
    bool convoCreate = await createConversation(myModel, otherModel);

    //Remove both the references from the matches list
    try{
      await firestoreInstance.doc(myRef).update({'matches': FieldValue.arrayRemove([otherReference])});
    }catch(e){
      print('Deleting match reference failed');
    }

    return true;

  }

  ///Checks if two users are a match and returns a bool
  Future<bool> checkIfMatch(String otherUid) async{
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(uid).get();
    List<dynamic> res = result['likes'];

    var ref = firestoreInstance.collection('users').doc('$otherUid');
    String path = ref.path.toString();

    for(dynamic a in res){
      LikesModel like = LikesModel.fromJson(a);
      if(like.like.toString()==path){
        return true;
      }
    }

    return false;

  }

  ///CreateConversation
  Future<bool> createConversation(UserModel me, UserModel other) async{

    UserModel wModel = me.gender.toLowerCase() == 'female' ? me : other;
    var wRef = firestoreInstance.collection('users').doc('${wModel.uid}');
    UserModel mModel = me.gender.toLowerCase() == 'male' ? me : other;
    var mRef = firestoreInstance.collection('users').doc('${mModel.uid}');

    String convoId = wModel.uid + '_' + mModel.uid;

    //Create conversation model object
    ConversationModel convoModel = new ConversationModel(
      conversationId: convoId,
      lastMessage: LastMessageModel(message: 'No Chats', from: 'both', read: true, time: DateTime.now()),
      messageCount: 0,
      unreadMessage: 0,
      woman: wRef.path.toString(),
      man: mRef.path.toString(),
      lastUpdate: DateTime.now(),
    );

    ///Create the conversation
    DateTime date = DateTime.now();
    await conversationCollection.doc(convoId).set(convoModel.toJson());

    var convoRef = firestoreInstance.collection('conversations').doc('$convoId');

    //Update user messageList (both)
    await wRef.update({'messages' : FieldValue.arrayUnion([convoRef.path.toString()])});
    await mRef.update({'messages' : FieldValue.arrayUnion([convoRef.path.toString()])});

    //Send Message Creation notification
    MessagingService.sendToTopic(title: 'New Conversation Created', body: 'You can now chat with ${other.fullName}', topic: '${me.uid}_convo');

    return true;
  }


  ///Send message
  Future<void> sendMessage(String message, String replyTo, String type, String convoRef) async{

    UserModel me = await getMyInfo();

    DateTime date = new DateTime.now();

    //Create the Message model
    final MessageModel _messageModel = new MessageModel(message: message, from: me.uid, replyTo: replyTo, time: date, messageId: date.toIso8601String(), type: type);

    //Send the message
    try{
      await firestoreInstance.doc(convoRef).collection('conversation').doc(date.toIso8601String()).set(_messageModel.toJson());
    }catch(e){
      print('not creating the new collection');
    }

    //update the last message, message count, unread messages and last Update
    final LastMessageModel _lastMessage = new LastMessageModel(message: message, from: me.uid, read: false, time: date);
    await firestoreInstance.doc(convoRef).update({'lastMessage': _lastMessage.toJson(), 'messageCount': FieldValue.increment(1), 'unreadMessage': FieldValue.increment(1)});

    //Send the message notification
    MessagingService.sendToTopic(title: me.fullName, body: message, topic: convoRef.split('/')[1]);

  }


  ///Update the unread message count
  Future<List<UserModel>> updateUnreadMessage(String convoRef) async{
    await firestoreInstance.doc(convoRef).update({'unreadMessage': 0});
  }

  ///Get only 10 users
  Future<List<UserModel>> getTopPicksList() async{
    List<UserModel> myDates = [];
    List<dynamic> lastSeenDatesList = [];

    UserModel me = await getMyInfo();

    var result1 = await firestoreInstance.collection('users').doc(me.uid).get();
    lastSeenDatesList = result1['lastSeen'];

    var result = await firestoreInstance.collection('users').where('gender', isEqualTo: me.interest).get();

    result.docs.forEach((element) {
      if(!lastSeenDatesList.contains(UserModel.fromJson(element).uid)){
        myDates.add(UserModel.fromJson(element));
      }
    });

    return myDates;
  }

  ///Delete Message
  Future<void> deleteMessage(String convoRef, String messageId) async{
    //Delete the message
    await firestoreInstance.doc(convoRef).collection('conversation').doc(messageId).delete();

  }

  ///Delete the whole conversation with one person
  Future<void> deleteConversation(String convoRef) async{
    //get both Users reference
    var result = await firestoreInstance.doc(convoRef).get();
    String user1Ref = result['man'];
    String user2Ref = result['woman'];

    //Delete the conversation reference in both users messages list
    await firestoreInstance.doc(user1Ref).update({'messages': FieldValue.arrayRemove([convoRef])});
    await firestoreInstance.doc(user2Ref).update({'messages': FieldValue.arrayRemove([convoRef])});

    //Delete the conversation
    await firestoreInstance.doc(convoRef).delete();

  }

}