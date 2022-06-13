import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tour_info/model/content_type.dart';
import 'package:tour_info/model/tour_site_info.dart';
import 'package:http/http.dart' as http;
import '../model/signugu.dart';
import '../model/item.dart';

class SearchListPage extends StatefulWidget {
  final String title;

  const SearchListPage({Key? key, required this.title}): super(key: key);

  @override
  State<SearchListPage> createState() => _SearchListPage();
}

class _SearchListPage extends State<SearchListPage> {
  List<DropdownMenuItem<Item>> mSigunguList = List.empty(growable: true);
  List<DropdownMenuItem<Item>> mContentTypeList = List.empty(growable: true);
  List<TourSiteInfo> mTourSiteInfoList = List.empty(growable: true);

  final String TOURAPI_SERVICE_URL = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList";
  final String TOURAPI_AUTH_KEY = "X68VZ4yzvaHhstVEgV2Pt/gySvKQb9i8i0Cy3afwIYkvOYTGE0uBCJWRFT/fvRAQVTtaWVkAKGlSju/HA31dxw==";
  final String AREA_CODE_SEOUL = "1";

  Item? _selectedItemSigungu;
  Item? _selectedItemContentType;
  int _page = 1;

  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    mSigunguList = Sigungu().sigunguList;
    mContentTypeList = ContentType().contentTypeList;

    _selectedItemSigungu = mSigunguList[0].value;
    _selectedItemContentType = mContentTypeList[0].value;

    _scrollController = ScrollController();
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
                  DropdownButton<Item>(
                    items: mSigunguList,
                    onChanged: (value) {
                      setState(() {
                        _selectedItemSigungu = value!;
                      });
                    },
                    value: _selectedItemSigungu,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton<Item>(
                    items: mContentTypeList,
                    onChanged: (value) {
                      setState(() {
                        _selectedItemContentType = value!;
                      });
                    },
                    value: _selectedItemContentType,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _page = 1;
                      mTourSiteInfoList.clear();
                      _getTourSiteInfoList(_selectedItemSigungu!.value, _selectedItemContentType!.value, _page);
                      // _getTourSiteInfoList(1, 1, _page);
                    },
                    child: Text("검색", style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Hero(
                              tag: 'TouristSite$index',
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 1),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: _downloadImage(mTourSiteInfoList[index].imagePath),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text(mTourSiteInfoList[index].title!,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text("주소: ${mTourSiteInfoList[index].address}"),
                                  (mTourSiteInfoList[index].tel != null)
                                      ? Text("전화번호: ${mTourSiteInfoList[index].tel}")
                                      : Container(),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              ),
                              width: MediaQuery.of(context).size.width - 150,
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                  itemCount: mTourSiteInfoList.length,
                  controller: _scrollController,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  Future<void> _getTourSiteInfoList(int sigunguValue, int contentTypeValue, int page) async {
    final qParams = {
      'serviceKey': TOURAPI_AUTH_KEY,
      'MobileOS': 'AND',
      'MobileApp': 'Tour Info Flutter',
      'numOfRows': '10',
      'areaCode': AREA_CODE_SEOUL,
      'sigunguCode': '$sigunguValue',
      'contentTypeId': '$contentTypeValue',
      'pageNo': '$page',
      '_type': 'json',
    };

    Uri uri = Uri.parse(TOURAPI_SERVICE_URL).replace(queryParameters: qParams);
    var httpResponse = await http.get(uri);
    String httpResponseDecoded = utf8.decode(httpResponse.bodyBytes);
    print(httpResponseDecoded);

    var jsonResponse = json.decode(httpResponseDecoded);
    if(jsonResponse['response']['header']['resultCode'] == "0000") {
      if(jsonResponse['response']['body']['items'] == "") {
        _generateDialog("마지막 데이터입니다.");
      } else {
        List itemList = jsonResponse['response']['body']['items']['item'];
        for(var item in itemList) {
          setState(() {
            mTourSiteInfoList.add(TourSiteInfo.fromJson(item));
          });
        }
      }
    } else {
      print("Error: Cannot parse the json response.");
    }
  }

  ImageProvider _downloadImage(String? imagePath) {
    if(imagePath == null) {
      return AssetImage('assets/images/map_location.png');
    } else {
      return NetworkImage(imagePath);
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