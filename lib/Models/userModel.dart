import 'package:flutter/foundation.dart';

class UserModel{
  final String uid;
  final String email;
  final String fullName;
  final String bDate;
  final String gender;
  final String interest;
  final List<dynamic> photos;
  final String bio;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.fullName,
    @required this.bDate,
    @required this.gender,
    @required this.interest,
    @required this.photos,
    @required this.bio,
  });

  factory UserModel.fromJson(dynamic json){
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      fullName: json['fullName'],
      bDate: json['bDate'],
      gender: json['gender'],
      interest: json['interest'],
      photos: json['photos'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'bDate': bDate,
        'gender': gender,
        'interest': interest,
        'photos': photos,
        'bio': bio,
      };

}
