import 'package:flutter/material.dart';
import 'item.dart';

class Sigungu {
  List<DropdownMenuItem<Item>> sigunguList = List.empty(growable: true);

  Sigungu() {
    sigunguList.add(DropdownMenuItem(
      child: Text('강남구'),
      value: Item('강남구', 1),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('강동구'),
      value: Item('강동구', 2),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('강북구'),
      value: Item('강북구', 3),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('강서구'),
      value: Item('강서구', 4),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('관악구'),
      value: Item('관악구', 5),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('광진구'),
      value: Item('광진구', 6),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('구로구'),
      value: Item('구로구', 7),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('금천구'),
      value: Item('금천구', 8),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('노원구'),
      value: Item('노원구', 9),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('도봉구'),
      value: Item('도봉구', 10),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('동대문구'),
      value: Item('동대문구', 11),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('동작구'),
      value: Item('동작구', 12),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('마포구'),
      value: Item('마포구', 13),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('서대문구'),
      value: Item('서대문구', 14),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('서초구'),
      value: Item('서초구', 15),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('성동구'),
      value: Item('성동구', 16),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('성북구'),
      value: Item('성북구', 17),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('송파구'),
      value: Item('송파구', 18),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('양천구'),
      value: Item('양천구', 19),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('영등포구'),
      value: Item('영등포구', 20),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('용산구'),
      value: Item('용산구', 21),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('은평구'),
      value: Item('은평구', 22),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('종로구'),
      value: Item('종로구', 23),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('중구'),
      value: Item('중구', 24),
    ));
    sigunguList.add(DropdownMenuItem(
      child: Text('중랑구'),
      value: Item('중랑구', 25),
    ));
  }
}