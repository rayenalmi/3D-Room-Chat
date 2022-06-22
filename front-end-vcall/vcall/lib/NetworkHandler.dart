import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class NetworkHaundler {
  String BaseURL = "http://192.168.1.100:3000";
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<dynamic> SimplePost(String url, Map<String, dynamic> body) async {
    String? token =
        await storage.read(key: "token", aOptions: _getAndroidOptions());
    var res = await http.post(Uri.parse("${BaseURL}${url}"),
        headers: {
          'Context-Type': 'application/json;charSet=UTF-8',
          'x-access-token': '${token}'
        },
        body: body);
    return res;
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    String? token =
        await storage.read(key: "token", aOptions: _getAndroidOptions());
    var res = await http.put(Uri.parse("${BaseURL}${url}"),
        headers: {
          'Context-Type': 'application/json;charSet=UTF-8',
          'x-access-token': '${token}'
        },
        body: body);
    return res;
  }

  Future get(String url) async {
    String? token =
        await storage.read(key: "token", aOptions: _getAndroidOptions());
    var res = await http.get(
      Uri.parse("${BaseURL}${url}"),
      headers: {
        'Context-Type': 'application/json;charSet=UTF-8',
        'x-access-token': '${token}'
      },
    );
    return res;
  }

  Future delete(String url) async {
    var response = await http.delete(Uri.parse("${BaseURL}${url}"));
    return response;
  }
}
