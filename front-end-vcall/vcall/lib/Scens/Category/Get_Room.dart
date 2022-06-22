import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:vcall/Models/Category_Model.dart';
import 'package:vcall/Models/Room.dart';
import 'package:vcall/Models/Room_pupulate.dart';
import 'package:vcall/Models/User.dart';
import 'package:vcall/NetworkHandler.dart';
import 'package:vcall/Scens/RoomUnity/RoomToJoinGuest.dart';
import 'package:vcall/Scens/RoomUnity/chat_screen.dart';

class Get_Rooms extends StatefulWidget {
  Get_Rooms({Key? key, this.animationController, this.category})
      : super(key: key);

  final AnimationController? animationController;
  final Category? category;

  @override
  State<Get_Rooms> createState() => Get_RoomsState();
}

class Get_RoomsState extends State<Get_Rooms> {
  var networkHandler = NetworkHaundler();

  List<Room> room_filtered = <Room>[];

  Future getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    return networkHandler.get("/getrooms/${widget.category?.cathegory}");
  }

  /* void filter_rooms(String categ) {
    for (var i in rooms) {
      if (i.category.toString() == categ) {
        room_filtered.add(i);
      }
    }
  }*/

  @override
  void initState() {
    super.initState();
    // filter_rooms(widget.category!.cathegory.toString());
  }

  Widget Card_Room(RoomPop r) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.only(
        left: 5.0,
        top: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(0xff132137),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.65),
            spreadRadius: 8,
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
          onTap: () async {
            var res = await networkHandler.get('/get/userbyid/');
            var body = jsonDecode(res.body);
            var user = User.fromJson(body);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RoomToJoinGuest(username: user.first_name!)));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.category!.path_iamge.toString()),
                maxRadius: 25,
                minRadius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Name : ",
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color.fromARGB(255, 149, 190, 255),
                          )),
                      Text(r.name.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color(0xFFFFFFFF),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Created By : ",
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color.fromARGB(255, 149, 190, 255),
                          )),
                      Text(r.owner!.first_name.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color(0xFFFFFFFF),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Date : ",
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color.fromARGB(255, 149, 190, 255),
                          )),
                      Text(r.date.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color(0xFFFFFFFF),
                          )),
                      Text(" At ",
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color.fromARGB(255, 149, 190, 255),
                          )),
                      Text(r.time.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(13),
                            color: Color(0xFFFFFFFF),
                          )),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              var body = jsonDecode(snapshot.data.body)['room'] as List;
              List<RoomPop> LR =
                  body.map((room) => RoomPop.fromJson(room)).toList();
              var scrollController;
              return ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      24,
                  bottom: 62 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: LR.length,
                itemBuilder: (BuildContext context, int index) {
                  widget.animationController?.forward();
                  return Column(
                    children: [
                      Card_Room(LR[index]),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ]),
    );
  }
}
