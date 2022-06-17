import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  final DatabaseReference databaseReference;
  final String currentUserId;

  const SettingsPage({
    Key? key,
    required this.title,
    required this.databaseReference,
    required this.currentUserId,
  }): super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(

      ),
    );
  }
}