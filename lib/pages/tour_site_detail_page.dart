import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_info/model/impairment_info.dart';
import '../model/review.dart';
import '../model/tour_site.dart';
import '../my_sliver_persistent_header_delegate.dart';
import '../util/util.dart';

class TourSiteDetailPage extends StatefulWidget {
  final String title;
  final DatabaseReference databaseReference;
  final TourSite tourSite;
  final int index;
  final String currentUserId;

  const TourSiteDetailPage({
    Key? key,
    required this.title,
    required this.databaseReference,
    required this.tourSite,
    required this.index,
    required this.currentUserId,
  }): super(key: key);

  @override
  State<TourSiteDetailPage> createState() => _TourSiteDetailPage();
}

class _TourSiteDetailPage extends State<TourSiteDetailPage> {
  DatabaseReference? _tourSitesDatabaseReference;
  List<Review> mReviewList = List.empty(growable: true);

  TextEditingController _teReviewController = TextEditingController();

  Completer<GoogleMapController> _gMapCompleter = Completer();
  LatLng? _initialMapPosition;
  CameraPosition? _initialCameraPosition;

  ImpairmentInfo? mImpairmentInfo;
  bool _impairmentEvaluationExists = false;
  double _visualImpairmentEvaluation = 0;
  double _physicalImpairmentEvaluation = 0;

  @override
  void initState() {
    super.initState();
    _tourSitesDatabaseReference = widget.databaseReference.child("tourSites");
    _getReviews();

    _initialMapPosition = LatLng(
      double.parse(widget.tourSite.mapy.toString()),
      double.parse(widget.tourSite.mapx.toString()),
    );
    _initialCameraPosition = CameraPosition(
      target: _initialMapPosition!,
      zoom: 13,
    );

    _getImpairmentInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
/*      appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.tourSite.title!, style: TextStyle(color: Colors.white, fontSize: 20),),
              centerTitle: true,
              titlePadding: EdgeInsets.only(top: 10),
            ),
            pinned: true,
            backgroundColor: Colors.deepOrangeAccent,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'TourSite${widget.index}',
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: Util.downloadImage(widget.tourSite.imagePath),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:20, bottom: 20),
                        child: Text(widget.tourSite.address!, style: TextStyle(fontSize: 16),),
                      ),
                      _getGoogleMap(),
                      _impairmentEvaluationExists
                        ? _showImpairmentEvaluation()
                        : _initImpairmentEvaluation(),
                    ],
                  ),
                ),
              ),
            ])
          ),
          SliverPersistentHeader(
            delegate: MySliverPersistentHeaderDelegate(
              minHeight: 30,
              maxHeight: 60,
              child: Container(
                color: Colors.lightBlueAccent,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("후기", style: TextStyle(fontSize: 16, color: Colors.white),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Card(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    child: Text("${mReviewList[index].id}: ${mReviewList[index].content}, ${mReviewList[index].createTime}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  onDoubleTap: () {
                    if(mReviewList[index].id == widget.currentUserId) {
                      _deleteReview(widget.currentUserId);
                      setState(() {
                        mReviewList.removeAt(index);
                      });
                    }
                  },
                ),
              );
            }, childCount: mReviewList.length),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("후기 작성"),
                        content: TextField(
                          controller: _teReviewController,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              _insertReview(Review(
                                id: widget.currentUserId,
                                content: _teReviewController.value.text,
                                createTime: DateTime.now().toIso8601String(),
                              ));
                              Navigator.of(context).pop();
                            },
                            child: Text("작성"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("취소"),
                          ),
                        ],
                      );
                    }
                  );
                },
                child: Text("후기 작성"),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  ImageProvider _downloadImage(String? imagePath) {
    if(imagePath == null) {
      return AssetImage('assets/images/map_location.png');
    } else {
      return NetworkImage(imagePath);
    }
  }

  Widget _getGoogleMap() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      height: 400,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition!,
        onMapCreated: (GoogleMapController controller) {
          _gMapCompleter.complete(controller);
        },
        markers: _createMarkers(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId(widget.tourSite.hashCode.toString()),
        position: _initialMapPosition!,
        flat: true
      ),
    };
  }

  void _getReviews() {
    _tourSitesDatabaseReference!
      .child(widget.tourSite.id.toString())
      .child("reviews")
      .onChildAdded
      .listen((event) {
        if(event.snapshot.exists) {
          setState(() {
            mReviewList.add(Review.fromSnapshot(event.snapshot));
          });
        }
      }
    );
  }

  void _insertReview(Review review) {
    _tourSitesDatabaseReference!
      .child(widget.tourSite.id.toString())
      .child("reviews")
      .child(widget.currentUserId)  // not push()
      .set(review.toJson());
  }

  void _deleteReview(String key) {
    _tourSitesDatabaseReference!
      .child(widget.tourSite.id.toString())
      .child("reviews")
      .child(key)  // not push()
      .remove();
  }

  void _getImpairmentInfo() {
    _tourSitesDatabaseReference!
      .child(widget.tourSite.id.toString())
      .child("impairmentInfo")
      .onValue
      .listen((event) {
        if(event.snapshot.exists) {
          mImpairmentInfo = ImpairmentInfo.fromSnapshot(event.snapshot);
          setState(() {
            _impairmentEvaluationExists = true;
          });
        } else {
          setState(() {
            _impairmentEvaluationExists = false;
          });
        }
      });
  }

  Widget _initImpairmentEvaluation() {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text("장애 이용도 평가가 없습니다. 평가해 주세요."),
            Text("시각장애인 이용도 점수: ${_visualImpairmentEvaluation.floor()}"),
            Padding(
              padding: EdgeInsets.all(10),
              child: Slider(
                value: _visualImpairmentEvaluation,
                min: 0,
                max: 5,
                onChanged: (value) {
                  setState(() {
                    _visualImpairmentEvaluation = value;
                  });
                },
              ),
            ),
            Text("지체장애인 이용도 점수: ${_physicalImpairmentEvaluation.floor()}"),
            Padding(
              padding: EdgeInsets.all(10),
              child: Slider(
                value: _physicalImpairmentEvaluation,
                min: 0,
                max: 5,
                onChanged: (value) {
                  setState(() {
                    _physicalImpairmentEvaluation = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _insertImpairmentInfo(ImpairmentInfo(
                  id: widget.currentUserId,
                  visualImpairmentEvaluation: _visualImpairmentEvaluation.floor(),
                  physicalImpairmentEvaluation: _physicalImpairmentEvaluation.floor(),
                  createTime: DateTime.now().toIso8601String(),
                ));
                setState(() {
                  _impairmentEvaluationExists = true;
                });
              },
              child: Text("평가 저장"),
            ),
          ],
        ),
      ),
    );
  }

  void _insertImpairmentInfo(ImpairmentInfo impairmentInfo) {
    _tourSitesDatabaseReference!
      .child(widget.tourSite.id.toString())
      .child("impairmentInfo")
      .set(impairmentInfo.toJson());
  }

  Widget _showImpairmentEvaluation() {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.remove_red_eye, size: 40, color: Colors.orange,),
              Text("시각장애인 이용도 점수: ${mImpairmentInfo!.visualImpairmentEvaluation}",
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.accessible, size: 40, color: Colors.orange,),
              Text("지체장애인 이용도 점수: ${mImpairmentInfo!.physicalImpairmentEvaluation}",
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(
            height: 20,
          ),
          Text("작성자: ${mImpairmentInfo!.id}"),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _impairmentEvaluationExists = false;
                _visualImpairmentEvaluation = 0;
                _physicalImpairmentEvaluation = 0;
              });
            },
            child: Text("새로 작성"),
          ),
        ],
      ),
    );
  }
}

