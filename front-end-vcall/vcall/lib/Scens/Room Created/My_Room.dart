import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:vcall/Models/Category_Model.dart';
import 'package:vcall/Models/Room.dart';
import 'package:vcall/NetworkHandler.dart';
import 'package:vcall/Scens/Room%20Created/Update_Room.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vcall/Scens/RoomUnity/RoomToJoin.dart';

class My_Room extends StatefulWidget {
  My_Room({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  State<My_Room> createState() => My_RoomState();
}

class My_RoomState extends State<My_Room> {
  final ScrollController scrollController = ScrollController();
  var networkHandler = NetworkHaundler();
  @override
  void initState() {
    super.initState();
  }

  Future getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    return networkHandler.get('/getroom');
  }

  Widget Card_Room(Room r) {
    return Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoomToJoin(username: r.owner!)));
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.play_arrow,
              label: 'Start',
            ),
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.leftToRightWithFade,
                        child: Update_Room(id: r.id!)));
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.build,
              label: 'Update',
            ),
            SlidableAction(
              onPressed: (context) {
                try {
                  var res = networkHandler.delete("/delete/room/${r.id}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${r.name} Deleted'),
                    ),
                  );
                  getData();
                } catch (e) {
                  print(e);
                }
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            left: 10.0,
            // top: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xFFFFFFFF),
          ),
          child: InkWell(
            onTap: () {
              setState(() {});
            },
            child: Column(children: [
              Row(
                children: [
                  Text("Name : ",
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                        color: Color.fromARGB(255, 149, 190, 255),
                      )),
                  Text(r.name.toString(),
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Category : ",
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                        color: Color.fromARGB(255, 149, 190, 255),
                      )),
                  Text(r.category.toString(),
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Date & Time: ",
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                        color: Color.fromARGB(255, 149, 190, 255),
                      )),
                  Text(r.date.toString(),
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                      )),
                  Text(" "),
                  Text(r.time.toString(),
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).scale(14),
                      )),
                ],
              ),
            ]),
          ),
        ));
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
              List<Room> LR = body.map((room) => Room.fromJson(room)).toList();
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

        /*ListView.builder(
          itemCount: my_room.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 16),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card_Room(my_room[index]),
                SizedBox(
                  height: 10,
                )
              ],
            );
          },
        ),*/
      ]),
    );
  }
}
