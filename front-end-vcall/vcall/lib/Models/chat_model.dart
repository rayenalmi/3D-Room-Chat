import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.id,
    required this.username,
    required this.sentAt,
    required this.message,
  });

  String id;
  String username;
  String sentAt;
  String message;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        username: json["username"],
        sentAt: json["sentAt"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "sentAt": sentAt,
        "message": message,
      };
}
