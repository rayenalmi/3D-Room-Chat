import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';

import '../../Models/User.dart';
import '../../NetworkHandler.dart';
import 'chat_screen.dart';

class RoomToJoinGuest extends StatefulWidget {
  final String username;
  const RoomToJoinGuest({
    Key? key,
    required this.username,
  }) : super(key: key);
  @override
  _RoomToJoinGuestState createState() => _RoomToJoinGuestState();
}

class _RoomToJoinGuestState extends State<RoomToJoinGuest> {
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
        title: const Text('Meet'),
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
    controller?.send(
      'GameManager',
      'SetAllPlayerPrefs',
      '${user.id}@${user.first_name}@${user.last_name}@GUEST',
    );
  }

  void onUnityViewReattached(UnityViewController controller) {
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(UnityViewController controller, String? message) {
    print('onUnityViewMessage');

    print(message);
  }
}
