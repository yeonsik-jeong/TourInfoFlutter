import 'package:flutter/material.dart';
import 'package:tour_info/pages/search_list_page.dart';
import 'package:tour_info/pages/favorites_page.dart';
import 'package:tour_info/pages/settings_page.dart';

class MaterialMain extends StatefulWidget {
  final String title;

  const MaterialMain({Key? key, required this.title}) : super(key: key);

  @override
  State<MaterialMain> createState() => _MaterialMain();
}

class _MaterialMain extends State<MaterialMain> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
/*      appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: TabBarView(
        children: <Widget>[
          SearchListPage(title: "검색",),
          FavoritesPage(title: "즐겨찾기",),
          SettingsPage(title: "설정",),
        ],
        controller: _tabController,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.map),),
          Tab(icon: Icon(Icons.star),),
          Tab(icon: Icon(Icons.settings),),
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: _tabController,
      ),
    );
  }
}