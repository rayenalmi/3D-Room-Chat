import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vcall/Models/Room.dart';
import 'package:vcall/NetworkHandler.dart';
import 'package:vcall/home.dart';

class Update_Room extends StatefulWidget {
  Update_Room({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<Update_Room> createState() => _Update_RoomState();
}

class _Update_RoomState extends State<Update_Room>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  var networkHandler = NetworkHaundler();
  late Room room;
  String meeting_name = "";
  List<String> emails = [];
  String category_hold = "category";
  String dropdownvalue = 'general';
  late DateTime _mydatetime;
  String day = DateFormat('dd-MM-yyyy').format(DateTime.now());
  TimeOfDay time = TimeOfDay.now();
  String code = "";
  late String error_text;
  bool error_exist = false;
  bool updated = false;

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<Offset> _name_animation = Tween<Offset>(
    begin: const Offset(10, 0.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.0,
      1.0,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _date_animation = Tween<Offset>(
    begin: const Offset(10, 0.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.2,
      1.0,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _time_animation = Tween<Offset>(
    begin: const Offset(10, 0.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.4,
      1.0,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _category_animation = Tween<Offset>(
    begin: const Offset(10, 0.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.6,
      1.0,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _gests_animation = Tween<Offset>(
    begin: const Offset(10, 0.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.8,
      1.0,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<double> _button_animation = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.0,
      1.0,
      curve: Curves.fastOutSlowIn,
    ),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      code = getRandomString(5);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void return_to_home() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    return networkHandler.get('/getRoomById/${widget.id}');
  }

  Widget error_widget() {
    return new Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromARGB(255, 187, 193, 202),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Color.fromARGB(255, 221, 66, 66)),
          Expanded(
            child: Text("ERROR : ${error_text}"),
          )
        ],
      ),
    );
  }

  Future Update_Room(String id) async {
    try {
      Map<String, dynamic> data = {
        "date": day,
        "time": time.format(context),
        "name": meeting_name,
        "all_invits": emails.toString(),
        "category": dropdownvalue,
        "code": code
      };

      var res = await networkHandler.put("/update/room/$id", data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          error_exist = false;
          updated = true;
        });
      } else {
        var er = jsonDecode(res.body);
        setState(() {
          error_text = er['message'];
          error_exist = true;
          updated = false;
        });
      }
      return res.statusCode;
    } catch (e) {
      print(e);
    }
  }

  List<String> convertToList(String ch) {
    var res = ch.substring(1, ch.length - 1);
    return res.split(",");
  }

  String separeString(String ch) {
    var res = ch.substring(1, ch.length - 1);
    return res.replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Update Meeting"),
        ),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            var body = jsonDecode(snapshot.data.body);
            room = Room.fromJson(body["room"]);
            // dropdownvalue = room.category!.toLowerCase();
            category_hold = room.category!.toLowerCase();
            emails = convertToList(body["room"]["all_invits"][0]);
            meeting_name = room.name!;
            return ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    24,
                bottom: 62 + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 200,
                        ),
                        if (error_exist == true)
                          error_widget()
                        else
                          SizedBox(
                            height: 50,
                            width: 200,
                          ),
                        SlideTransition(
                          position: _name_animation,
                          child: Text(
                            "Meeting's Name",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF132137),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SlideTransition(
                          position: _name_animation,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 16,
                            ),
                            height: 58,
                            width: 50 +
                                MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width * 0.25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: TextField(
                              controller:
                                  TextEditingController(text: room.name),
                              onChanged: (text) {
                                meeting_name = text;
                              },
                              decoration: InputDecoration(
                                //hintText: "Enter the Meeting's name please",
                                /*label: Text('Reunion Name')*/
                                hintStyle: TextStyle(fontSize: 20),
                                border: InputBorder.none,
                                icon: Icon(Icons.format_color_text),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SlideTransition(
                          position: _date_animation,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Meeting's Date ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF132137),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.event),
                                  color: Color(0xFF132137),
                                  onPressed: () async {
                                    _mydatetime = (await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime(2050),
                                    ))!;
                                    setState(() {
                                      //time= _mydatetime.toString() ;
                                      day = DateFormat('dd-MM-yyyy')
                                          .format(_mydatetime);
                                    });
                                  },
                                ),
                                Text(day),
                              ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SlideTransition(
                          position: _time_animation,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Meeting's Time",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF132137),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.access_time),
                                  color: Color(0xFF132137),
                                  onPressed: () async {
                                    TimeOfDay? newtime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: int.parse(
                                              room.time!.split(":")[0]),
                                          minute: int.parse(
                                              room.time!.split(":")[1])),
                                    );
                                    setState(() {
                                      time = newtime!;
                                    });
                                  },
                                ),
                                Text('${time.hour} : ${time.minute}'),
                              ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SlideTransition(
                          position: _category_animation,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Category :",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFF132137),
                                  ),
                                ),
                                DropdownButton<String>(
                                  value:
                                      dropdownvalue, //room.category!.toLowerCase(),
                                  icon: Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Color(0xFF132137), fontSize: 25),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                      category_hold = newValue;
                                    });
                                  },
                                  items: <String>[
                                    "general",
                                    "mecanics",
                                    "coding",
                                    "electric ity",
                                    "industry",
                                    "education"
                                  ]
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                              child: Text(item), value: item))
                                      .toList(), /*.map<DropdownMenuItem<String>>(
                                      (String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),*/
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SlideTransition(
                          position: _gests_animation,
                          child: Text(
                            'Guests',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF132137),
                            ),
                          ),
                        ),
                        SlideTransition(
                            position: _gests_animation,
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom:
                                    MediaQuery.of(context).padding.bottom + 16,
                              ),
                              height: 58,
                              width: 50 +
                                  MediaQuery.of(context).size.width -
                                  (MediaQuery.of(context).size.width * 0.25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: separeString(
                                        body["room"]["all_invits"][0])),
                                onChanged: (text) {
                                  emails = text.split(" ");
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 20),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.account_circle_rounded),
                                ),
                              ),
                            )),
                        ScaleTransition(
                          scale: _button_animation,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 16,
                            ),
                            height: 58,
                            width: 70 +
                                MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width * 0.8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(38.0),
                              color: Color(0xFF132137),
                            ),
                            child: InkWell(
                              onTap: () async {
                                var r = await Update_Room(room.id!);
                                print(r);
                                if (error_exist == false) {
                                  print(error_exist);
                                  setState(() {
                                    updated = true;
                                  });
                                }
                                if (updated == true) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Center(
                                        child: Row(children: [
                                          const Text("Meeting Updated"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.add_task,
                                            color: Colors.green,
                                          )
                                        ]),
                                      ),
                                      content: Text(code),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              return_to_home();
                                            },
                                            child: Center(
                                              child: const Text('OK'),
                                            )),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Update',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.create, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
