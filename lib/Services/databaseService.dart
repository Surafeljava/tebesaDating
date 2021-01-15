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
    print('******* Database Service ******* $downloadUrl');
    return downloadUrl;

  }

  Future<void> addNewUser(UserModel _userModel, String _uid) async {
    await userCollection.doc(_uid).set(_userModel.toJson());
  }

}