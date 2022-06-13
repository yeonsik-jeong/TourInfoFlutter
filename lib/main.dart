import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'material_main.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      return MaterialApp(
        title: '여행 정보',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
//        home: const MaterialMain(title: ''),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(title: '',),
//          '/signup': (context) => SignupPage(title: '회원가입',),
          '/main': (context) => MaterialMain(title: '',),
        },
      );
    } else {  // iOS
      return CupertinoApp();
    }
  }
}


