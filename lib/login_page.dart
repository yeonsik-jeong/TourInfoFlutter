import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tour_info/signup_page.dart';

import 'model/user.dart';

class LoginPage extends StatefulWidget {
  final String title;

  const LoginPage({Key? key, required this.title}): super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _teIdController = TextEditingController();
  final TextEditingController _tePasswordController = TextEditingController();
  DatabaseReference? _usersDatabaseReference;
  AnimationController? _animationController;
  Animation? _animation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _usersDatabaseReference = FirebaseDatabase.instance.ref().child('users');
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = Tween<double>(begin: 0, end: pi * 4).animate(_animationController!);

    _animationController!.repeat();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _toggleOpacity(_opacity);
      });
    });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
/*      appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController!,
                builder: (context, widget) {
                  return Transform.rotate(
                    angle: _animation!.value,
                    child: widget,
                  );
                },
                child: Icon(Icons.airplanemode_active, color: Colors.deepOrangeAccent, size: 80,),
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: Text("여행 정보", style: TextStyle(fontSize: 24),),
                ),
              ),
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _teIdController,
                        maxLines: 1,
                        decoration: InputDecoration(labelText: "아이디", border: OutlineInputBorder(),),
                      ),
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
                        decoration: InputDecoration(labelText: "비밀번호", border: OutlineInputBorder(),),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        TextButton(
                            onPressed: _login,
                            child: Text("로그인")
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupPage(title: '회원가입', databaseReference: _usersDatabaseReference!)
                            ));
                          },
                          child: Text("회원가입")
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  void _toggleOpacity(double opacity) {
    _opacity = (opacity == 1.0)? opacity - 1.0: opacity + 1.0;
  }

  void _login() {
    if(_teIdController.value.text.isEmpty) {
      _generateDialog("아이디를 입력하세요.");
    } else if(_tePasswordController.value.text.isEmpty) {
      _generateDialog("비밀번호를 입력하세요.");
    } else {
      _usersDatabaseReference!
        .orderByChild('id').equalTo(_teIdController.value.text)
        .once()
        .then((event) {
          print("[id] ${_teIdController.value.text}, [event.snapshot.value] ${event.snapshot.value}");
          if(!event.snapshot.exists) {
            _generateDialog("아이디가 없습니다. 먼저 회원가입을 하세요.");
          } else {
            Map<dynamic, dynamic> map = event.snapshot.value as Map;
            if(map.length == 1) {
              map.forEach((key, value) {
                User user = User.fromJson(value);
                var passwordDigest = sha1.convert(utf8.encode(_tePasswordController.value.text));
                print("user.password:             ${user.password}");
                print("passwordDigest.toString(): ${passwordDigest.toString()}");
                if(user.password == passwordDigest.toString()) {
                  Navigator.of(context).pushReplacementNamed('/main',
                    arguments: _teIdController.value.text
                  );
                } else {
                  _generateDialog("비밀번호가 틀립니다.");
                }
              });
            } else {
              _generateDialog("중복된 아이디입니다.");
            }
          }
        });
    }
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