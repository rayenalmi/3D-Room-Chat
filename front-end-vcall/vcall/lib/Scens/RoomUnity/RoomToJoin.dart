import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';

import '../../Models/User.dart';
import '../../NetworkHandler.dart';
import 'chat_screen.dart';

class RoomToJoin extends StatefulWidget {
  final String username;
  const RoomToJoin({
    Key? key,
    required this.username,
  }) : super(key: key);
  @override
  _RoomToJoinState createState() => _RoomToJoinState();
}

class _RoomToJoinState extends State<RoomToJoin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UnityViewPage(
                          username: widget.username,
                        )));
          },
          child: Text('Join'),
        ),
      ),
    );
  }
}

class UnityViewPage extends StatefulWidget {
  final String username;
  const UnityViewPage({
    Key? key,
    required this.username,
  }) : super(key: key);
  @override
  _UnityViewPageState createState() => _UnityViewPageState();
}

class _UnityViewPageState extends State<UnityViewPage> {
  late bool openUnityMax = true;
  var networkHandler = NetworkHaundler();
  UnityViewController? unityViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double sizeToUnity(bool tr) {
    if (tr == true) {
      return 0.7;
    } else {
      return 0.2;
    }
  }

  double sizeToChat(bool tr) {
    if (tr == false) {
      return 0.7;
    } else {
      return 0.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          width: MediaQuery.of(context).size.width * 0.93,
          child: UnityView(
            onCreated: onUnityViewCreated,
            onReattached: onUnityViewReattached,
            onMessage: onUnityViewMessage,
          ),
        ),
        /*Row(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    openUnityMax = !openUnityMax;
                  });
                  print(openUnityMax);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: openUnityMax ? Icon(Icons.message) : Icon(Icons.close),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width *
                    sizeToChat(openUnityMax),
                child: ChatScreen(username: widget.username),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width:
                MediaQuery.of(context).size.width * sizeToUnity(openUnityMax),
            child: UnityView(
              onCreated: onUnityViewCreated,
              onReattached: onUnityViewReattached,
              onMessage: onUnityViewMessage,
            ),
          ),
        ],
      )*/
      ),
      drawer: Drawer(
        child: ChatScreen(username: widget.username),
      ),
    );
  }

  Future<void> onUnityViewCreated(UnityViewController? controller) async {
    print('onUnityViewCreated');

    unityViewController = controller;
    var res = await networkHandler.get('/get/userbyid/');
    var body = jsonDecode(res.body);
    //print(body);
    var user = User.fromJson(body);
    controller?.send('GameManager', 'SetAllPlayerPrefs', 'ADMIN'
        // '${user.id}@${user.first_name}@${user.last_name}@ADMIN',
        );
  }

  void onUnityViewReattached(UnityViewController controller) {
    unityViewController?.send('GameManager', 'SetAllPlayerPrefs', 'ADMIN');
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(UnityViewController controller, String? message) {
    print('onUnityViewMessage');
    unityViewController?.send('GameManager', 'SetAllPlayerPrefs', 'ADMIN');
    print(message);
  }
}
