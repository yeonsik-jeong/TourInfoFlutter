import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String title;

  const SettingsPage({Key? key, required this.title}): super(key: key);

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