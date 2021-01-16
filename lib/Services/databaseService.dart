import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbStore;
import 'package:flutter/foundation.dart';

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

  Future<void> getNewDates() async{
    UserModel me = await getMyInfo();
    //TODO finish this function
  }

  //For MainMessagingPage and Deleting Account
  Future<List<dynamic>> getMyMessagesList() async{
    String _uid = FirebaseAuth.instance.currentUser.uid.toString();
    var result = await firestoreInstance.collection('users').doc(_uid).get();
    return result['messages'];
  }



}