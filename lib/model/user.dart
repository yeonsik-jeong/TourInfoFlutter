import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class User {
  String? id;
  String? password;
  String? createTime;

  User({this.id, this.password, this.createTime});

  User.fromSnapshot(DataSnapshot snapshot) {
    print("User.fromSnapshot(): snapshot.value as Map: ${snapshot.value as Map} snapshot.key: ${snapshot.key}");
    var map = snapshot.value as Map;

    id = map['id'];
    password = map['password'];
    createTime = map['createTime'];
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['id'],
      password: json['password'],
      createTime: json['createTime']
    );
  }

/*  User.fromSnapshot(DataSnapshot snapshot):
    id = (snapshot.value as Map)['id'],
    password = (snapshot.value as Map)['password'],
    createTime = (snapshot.value as Map)['createTime'];*/

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'createTime': createTime,
    };
  }
}