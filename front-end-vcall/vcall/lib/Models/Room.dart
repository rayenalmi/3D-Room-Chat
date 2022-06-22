import 'package:flutter/material.dart';
import 'dart:convert';

class Room {
  final String? id;
  final String? owner;
  final String? date;
  final String? time;
  final List<String>? all_invites;
  final String? name;
  final String? category;
  final String? code;

  const Room({
    this.id,
    this.owner,
    this.name,
    this.category,
    this.date,
    this.time,
    this.all_invites,
    this.code,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      owner: json['owner'],
      date: json['date'],
      time: json['time'],
      name: json['name'],
      all_invites: json['all_invites'],
      category: json['category'],
      code: json['code'],
    );
  }
}
