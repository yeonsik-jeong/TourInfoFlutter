import 'package:firebase_database/firebase_database.dart';

class Review {
  String? id;
  String? content;
  String? createTime;

  Review({this.id, this.content, this.createTime});

  Review.fromSnapshot(DataSnapshot snapshot):
    id = (snapshot.value as Map)['id'],
    content = (snapshot.value as Map)['content'],
    createTime = (snapshot.value as Map)['createTime'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createTime': createTime,
    };
  }
}