import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tour_info/pages/tour_site_detail_page.dart';

import '../model/tour_site.dart';
import '../util/tour_site_sqlite_database_provider.dart';
import '../util/util.dart';

class FavoritesPage extends StatefulWidget {
  final String title;
  final DatabaseReference databaseReference;
  final String currentUserId;
  final TourSiteSQLiteDatabaseProvider databaseProvider;

  const FavoritesPage({
    Key? key,
    required this.title,
    required this.databaseReference,
    required this.currentUserId,
    required this.databaseProvider,
  }): super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPage();
}

class _FavoritesPage extends State<FavoritesPage> {
  Future<List<TourSite>>? mTourSiteList;

  @override
  void initState() {
    super.initState();
    mTourSiteList = _getTourSites();
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
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        TourSite tourSite = (snapshot.data as List<TourSite>)[index];
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
                                        image: Util.downloadImage(tourSite.imagePath),
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
                                      Text(tourSite.title!,
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      Text("주소: ${tourSite.address}"),
                                      (tourSite.tel != null)
                                        ? Text("전화번호: ${tourSite.tel}")
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
                                    tourSite: tourSite,
                                    index: index,
                                    currentUserId: widget.currentUserId,
                                  )
                              ));
                            },
                            onDoubleTap: () {
                              _deleteTourSite(context, tourSite);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("즐겨찾기에서 삭제했습니다."),)
                              );
                            },
                          ),
                        );
                      },
                      itemCount: (snapshot.data as List<TourSite>).length,
                    );
                  } else {
                    return Text("No DATA");
                  }
              }
              // return CircularProgressIndicator();
            },
            future: mTourSiteList,
          ),
        ),
      ),
    );
  }

  Future<List<TourSite>> _getTourSites() {
    return widget.databaseProvider.getTourSites();
  }

  void _deleteTourSite(BuildContext context, TourSite tourSite) {
    widget.databaseProvider.deleteTourSite(tourSite);
    setState(() {
      mTourSiteList = _getTourSites();
    });
  }
}