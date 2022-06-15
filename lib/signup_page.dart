import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';

class SignupPage extends StatefulWidget {
  final String title;
  final DatabaseReference databaseReference;

  const SignupPage({Key? key, required this.title, required this.databaseReference}): super(key: key);

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  DatabaseReference? _usersDatabaseReference;

  final TextEditingController _teIdController = TextEditingController();
  final TextEditingController _tePasswordController = TextEditingController();
  final TextEditingController _tePasswordCheckController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usersDatabaseReference = widget.databaseReference.child("users");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 136,
                    child: TextField(
                      controller: _teIdController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "아이디",
                        hintText: "4자 이상 입력하세요.",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _checkDuplicateId,
                    child: Text("중복"),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _tePasswordController,
                  maxLines: 1,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "비밀번호",
                    hintText: "6자 이상 입력하세요.",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _tePasswordCheckController,
                  maxLines: 1,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "비밀번호 확인",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _signup,
                child: Text("가입", style: TextStyle(color: Colors.white),),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  void _checkDuplicateId() {

  }

  void _signup() {
    if(_teIdController.value.text.length < 4) {
      _generateDialog("아이디를 4자 이상 입력하세요.");
    } else if(_tePasswordController.value.text.length < 6) {
      _generateDialog("비밀번호를 6자 이상 입력하세요.");
    } else if(_tePasswordController.value.text != _tePasswordCheckController.value.text) {
      _generateDialog("비밀번호가 서로 틀립니다.");
    } else {
      var passwordDigest = sha1.convert(utf8.encode(_tePasswordController.value.text));
      _insertUser(User(
        id: _teIdController.value.text,
        password: passwordDigest.toString(),
        createTime: DateTime.now().toIso8601String(),
      ));
    }
  }

  void _insertUser(User user) {
    _usersDatabaseReference!.push()
      .set(user.toJson())
      .then((_) {
        Navigator.of(context).pop();
      }
    );
  }

  void _generateDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      }
    );
  }
}