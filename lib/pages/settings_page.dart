import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  final DatabaseReference databaseReference;
  final String currentUserId;

  const SettingsPage({
    Key? key,
    required this.title,
    required this.databaseReference,
    required this.currentUserId,
  }): super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  DatabaseReference? _usersDatabaseReference;
  bool mPushEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _usersDatabaseReference = widget.databaseReference.child('users');
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
                  Text("푸시알림", style: TextStyle(fontSize: 20),),
                  Switch(
                    value: mPushEnabled,
                    onChanged: (value) {
                      setState(() {
                        mPushEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Text("로그아웃", style: TextStyle(fontSize: 20),),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  AlertDialog dialog = AlertDialog(
                    title: Text("회원탈퇴"),
                    content: Text("아이디 ${widget.currentUserId}를 삭제하시겠습니까?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _deleteUser(widget.currentUserId);
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        child: Text("예"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("아니오"),
                      ),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (context) => dialog,
                  );
                },
                child: Text("회원탈퇴", style: TextStyle(fontSize: 20),),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool("mPushEnabled", mPushEnabled);
  }

  Future<void> _loadSettings() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var value = sharedPref.getBool("mPushEnabled");
    setState(() {
      mPushEnabled = (value == null)? true: value;
    });
  }

  void _deleteUser(String id) {
    _usersDatabaseReference!
      .orderByChild('id').equalTo(id)
      .once()
      .then((event) {
        Map<dynamic, dynamic> map = event.snapshot.value as Map;
        if(map.length == 1) {
          map.forEach((key, value) {
            _usersDatabaseReference!.child(key).remove();
          });
        }
      }
    );
  }
}