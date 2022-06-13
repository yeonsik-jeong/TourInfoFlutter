import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final String title;

  const FavoritesPage({Key? key, required this.title}): super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPage();
}

class _FavoritesPage extends State<FavoritesPage> {
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