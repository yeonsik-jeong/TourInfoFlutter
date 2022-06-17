import 'package:flutter/material.dart';

class Util {
  static ImageProvider downloadImage(String? imagePath) {
    if(imagePath == null) {
      return AssetImage('assets/images/map_location.png');
    } else {
      return NetworkImage(imagePath);
    }
  }
}