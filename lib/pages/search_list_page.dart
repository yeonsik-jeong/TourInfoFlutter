import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tour_info/model/content_type.dart';
import 'package:tour_info/model/tour_site.dart';
import 'package:http/http.dart' as http;
import 'package:tour_info/pages/tour_site_detail_page.dart';

import '../model/signugu.dart';
import '../model/item.dart';
import '../util/tour_site_sqlite_database_provider.dart';
import '../util/util.dart';

class SearchListPage extends StatefulWidget {
  final String title;
  final DatabaseReference databaseReference;
  final String currentUserId;
  final TourSiteSQLiteDatabaseProvider databaseProvider;

  const SearchListPage({
    Key? key,
    required this.title,
    required this.databaseReference,
    required this.currentUserId,
    required this.databaseProvider,
  }): super(key: key);

  @override
  State<SearchListPage> createState() => _SearchListPage();
}

class _SearchListPage extends State<SearchListPage> {
  final String TOURAPI_SERVICE_URL = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList";
  final String TOURAPI_AUTH_KEY = "";
  final String AREA_CODE_SEOUL = "1";

  List<DropdownMenuItem<Item>> mSigunguList = List.empty(growable: true);
  List<DropdownMenuItem<Item>> mContentTypeList = List.empty(growable: true);
  List<TourSite> mTourSiteList = List.empty(growable: true);

  Item? _selectedItemSigungu;
  Item? _selectedItemContentType;
  int _page = 1;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    mSigunguList = Sigungu().sigunguList;
    mContentTypeList = ContentType().contentTypeList;

    _selectedItemSigungu = mSigunguList[0].value;
    _selectedItemContentType = mContentTypeList[0].value;

    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
        _page++;
        _getTourSiteList(_selectedItemSigungu!.value, _selectedItemContentType!.value, _page);
      }
    });
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
                      mTourSiteList.clear();
                      _getTourSiteList(_selectedItemSigungu!.value, _selectedItemContentType!.value, _page);
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
                              tag: 'TourSite$index',
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 1),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    // image: _downloadImage(mTourSiteList[index].imagePath),
                                    image: Util.downloadImage(mTourSiteList[index].imagePath),
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
                                  Text(mTourSiteList[index].title!,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text("주소: ${mTourSiteList[index].address}"),
                                  (mTourSiteList[index].tel != null)
                                      ? Text("전화번호: ${mTourSiteList[index].tel}")
                                      : Container(),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              ),
                              width: MediaQuery.of(context).size.width - 150,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TourSiteDetailPage(
                              title: '',
                              databaseReference: widget.databaseReference,
                              tourSite: mTourSiteList[index],
                              index: index,
                              currentUserId: widget.currentUserId,
                            )
                          ));
                        },
                        onDoubleTap: () {
                          _createTourSite(context, mTourSiteList[index]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("즐겨찾기에 추가했습니다."),)
                          );
                        },
                      ),
                    );
                  },
                  itemCount: mTourSiteList.length,
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

  Future<void> _getTourSiteList(int sigunguValue, int contentTypeValue, int page) async {
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
            mTourSiteList.add(TourSite.fromJson(item));
          });
        }
      }
    } else {
      print("Error: Cannot parse the json response.");
    }
  }

  void _createTourSite(BuildContext context, TourSite tourSite) {
    widget.databaseProvider.insertTourSite(tourSite);
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
