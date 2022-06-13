import 'package:flutter/material.dart';
import 'item.dart';

class ContentType {
  List<DropdownMenuItem<Item>> contentTypeList = List.empty(growable: true);

  ContentType() {
    contentTypeList.add(DropdownMenuItem(
      child: Text('관광지'),
      value: Item('관광지', 12),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('문화시설'),
      value: Item('문화시설', 14),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('행사/공연/축제'),
      value: Item('행사/공연/축제', 15),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('여행코스'),
      value: Item('여행코스', 25),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('레포츠'),
      value: Item('레포츠', 28),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('숙박'),
      value: Item('숙박', 32),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('쇼핑'),
      value: Item('쇼핑', 38),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('음식점'),
      value: Item('음식점', 39),
    ));
    contentTypeList.add(DropdownMenuItem(
      child: Text('전체'),
      value: Item('전체', 0),
    ));
  }
}