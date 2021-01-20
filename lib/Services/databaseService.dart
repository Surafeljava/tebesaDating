import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/datesState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbStore;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class DatabaseService with ChangeNotifier{

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

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
    await userCollection.doc(uid).update({'lastSeen':[], 'messages':[], 'likes':[]});
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





}