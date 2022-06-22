import 'dart:async';

import 'package:flutter/material.dart';
//import 'dart:html';

import 'package:http/http.dart' as http;

class Forget extends StatefulWidget {
  bool error_exist = false;
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> with TickerProviderStateMixin {
  late String Email = "";

  _ForgetState({
    Key? key,
  });

  Future Function_for_Send_Reset() async {
    var res = await http.post(Uri.parse("http://localhost:8080/send_email"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'email': Email,
          "URL": "window.location.href"
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Forget"),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
              child: Expanded(
                  child: Text("An Email will be send to reset ypu password"))),
          Padding(
            padding: EdgeInsets.only(left: 64, right: 64, bottom: 16, top: 16),
            child: TextField(
              controller: TextEditingController(text: Email),
              onChanged: (value) {
                Email = value;
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 20),
                border: InputBorder.none,
                icon: Icon(Icons.account_circle_rounded),
                hintText: "Email",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            height: 58,
            width: 50 +
                MediaQuery.of(context).size.height -
                (MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38.0),
              color: Color(0xFF132137),
            ),
            child: InkWell(
              onTap: () {
                Function_for_Send_Reset();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.email_sharp, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
