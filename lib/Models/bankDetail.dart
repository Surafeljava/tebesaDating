import 'dart:convert';
import 'package:flutter/material.dart';

class BankDetail {
  final String image;
  final String name;
  final String num;
  BankDetail({
    @required this.image,
    @required this.name,
    @required this.num,
  });

  BankDetail copyWith({
    String image,
    String name,
    String num,
  }) {
    return BankDetail(
      image: image ?? this.image,
      name: name ?? this.name,
      num: num ?? this.num,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'num': num,
    };
  }

  factory BankDetail.fromMap(Map<String, dynamic> map) {
    return BankDetail(
      image: map['image'],
      name: map['name'],
      num: map['num'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BankDetail.fromJson(String source) =>
      BankDetail.fromMap(json.decode(source));

  @override
  String toString() => 'BankDetail(image: $image, name: $name, num: $num)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankDetail &&
        other.image == image &&
        other.name == name &&
        other.num == num;
  }

  @override
  int get hashCode => image.hashCode ^ name.hashCode ^ num.hashCode;
}
