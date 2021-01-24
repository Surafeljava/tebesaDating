import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/messageModels.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/datesState.dart';
import 'package:dating/Services/messagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbStore;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class DatabaseService with ChangeNotifier{

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
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

  Future<void> addNewUser(UserModel _userModel, String _uid) async {
    await userCollection.doc(_uid).set(_userModel.toJson());
    await addNewUserAdditionalData();
  }

  Future<void> addNewUserAdditionalData() async{
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    await userCollection.doc(uid).update({'lastSeen':[], 'messages':[], 'likes':[], 'matches':[]});
  }

  Future<UserModel> getMyInfo() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return UserModel.fromJson(result);
  }

  Future<void> getNewDates(BuildContext context) async{

    List<UserModel> myDates = [];
    List<dynamic> lastSeenDatesList = [];

    UserModel me = await getMyInfo();
    //TODO finish this function
    String genderToFind = me.gender=='Male' ? 'Female' : 'Male';

    var result1 = await firestoreInstance.collection('users').doc(me.uid).get();
    lastSeenDatesList = result1['lastSeen'];

    var result = await firestoreInstance.collection('users').where('gender', isEqualTo: genderToFind).get();

    result.docs.forEach((element) {
      if(!lastSeenDatesList.contains(UserModel.fromJson(element).uid)){
        myDates.add(UserModel.fromJson(element));
      }
    });

    Provider.of<DatesState>(context, listen: false).addNewDates(myDates);

  }

  //For MainMessagingPage and Deleting Account
  Future<List<dynamic>> getMyMessagesList() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return result['messages'];
  }

  Future<List<dynamic>> getMyMatches() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return result['matches'];
  }

  //Function to be called on disLike button clicked
  Future<bool> updateOnDisLikes(String otherUid) async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var ref = firestoreInstance.collection('users').doc('$_uid');

    //update my lastSeen list
    ref.update({'lastSeen' : FieldValue.arrayUnion([otherUid])});
    return true;
  }

  //Function to be called on like button clicked
  Future<bool> updateOnLikes(String otherUid) async {
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var ref = firestoreInstance.collection('users').doc('$_uid');
    var refOther = firestoreInstance.collection('users').doc('$otherUid');

    //update my lastSeen list
    ref.update({'lastSeen' : FieldValue.arrayUnion([otherUid])});

    //update otherUsers liked list
    refOther.update({'likes': FieldValue.arrayUnion([ref.path.toString()])});

    return true;

  }

  //adding users to the match
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

  //Remove matches from their respective list on creating conversation
  Future<bool> removeMatches(String otherReference) async{
    //Prepare my reference
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(uid).get();
    final String myRef = firestoreInstance.collection('users').doc(uid).path.toString();
    final UserModel myModel = UserModel.fromJson(result);

    //Get other user model
    var result2 = await firestoreInstance.doc(otherReference).get();
    final UserModel otherModel = UserModel.fromJson(result);

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

  //Checks if two users are a match and returns a bool
  Future<bool> checkIfMatch(String otherUid) async{
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(uid).get();
    List<dynamic> res = result['likes'];

    var ref = firestoreInstance.collection('users').doc('$otherUid');
    String path = ref.path.toString();

    for(dynamic a in res){
      if(a.toString()==path){
        return true;
      }
    }

    return false;

  }

  //CreateConversation
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

    //Create the conversation
    DateTime date = DateTime.now();
    await conversationCollection.doc(convoId).set(convoModel.toJson());
//    await conversationCollection.doc(convoId)
//        .collection('conversation').doc(date.toIso8601String())
//        .set(MessageModel(message: '${date.toIso8601String()}', from: 'tebesa', replyTo: '', time: date, messageId: date.toIso8601String(), type: 'text').toJson());

    var convoRef = firestoreInstance.collection('conversations').doc('$convoId');

    //Update user messageList (both)
    await wRef.update({'messages' : FieldValue.arrayUnion([convoRef.path.toString()])});
    await mRef.update({'messages' : FieldValue.arrayUnion([convoRef.path.toString()])});

    //Send Message Creation notification
    MessagingService.sendToTopic(title: 'New Conversation Created', body: 'You can now chat with ${other.fullName}', topic: '${me.uid}_convo');

    return true;
  }


  //Send message
  Future<void> sendMessage(String message, String replyTo, String type, String convoRef) async{

    UserModel me = await getMyInfo();
    print('******** Me ******** ${me.uid}');

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

  //Delete Message
  Future<void> deleteMessage(String convoRef, String messageId) async{
    //Delete the message
    await firestoreInstance.doc(convoRef).collection('conversation').doc(messageId).delete();

  }

  //Delete the whole conversation with one person
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