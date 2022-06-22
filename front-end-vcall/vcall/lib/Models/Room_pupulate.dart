import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:vcall/Models/User.dart';

class RoomPop {
  final String? id;
  final User? owner;
  final String? date;
  final String? time;
  final List<String>? all_invites;
  final String? name;
  final String? category;
  final String? code;

  const RoomPop({
    this.id,
    this.owner,
    this.name,
    this.category,
    this.date,
    this.time,
    this.all_invites,
    this.code,
  });

  factory RoomPop.fromJson(Map<String, dynamic> json) {
    return RoomPop(
      id: json['_id'],
      owner: User.fromJson(json['owner']),
      date: json['date'],
      time: json['time'],
      name: json['name'],
      all_invites: json['all_invites'],
      category: json['category'],
      code: json['code'],
    );
  }
}
