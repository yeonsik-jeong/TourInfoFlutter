import 'package:firebase_database/firebase_database.dart';

class ImpairmentInfo {
  String? key;
  String? id;
  int? visualImpairmentEvaluation;
  int? physicalImpairmentEvaluation;
  String? createTime;

  ImpairmentInfo({this.key, this.id, this.visualImpairmentEvaluation, this.physicalImpairmentEvaluation, this.createTime});

  ImpairmentInfo.fromSnapshot(DataSnapshot snapshot):
    key = snapshot.key,
    id = (snapshot.value as Map)['id'],
    visualImpairmentEvaluation = (snapshot.value as Map)['visualImpairmentEvaluation'],
    physicalImpairmentEvaluation = (snapshot.value as Map)['physicalImpairmentEvaluation'],
    createTime = (snapshot.value as Map)['createTime'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visualImpairmentEvaluation': visualImpairmentEvaluation,
      'physicalImpairmentEvaluation': physicalImpairmentEvaluation,
      'createTime': createTime,
    };
  }
}