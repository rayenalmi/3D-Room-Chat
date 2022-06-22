import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vcall/Models/User.dart';

import 'package:http/http.dart' as http;
import 'package:vcall/NetworkHandler.dart';

class Register extends StatefulWidget {
  bool error_exist = false;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  var networkHandler = NetworkHaundler();
  final bool errorExist = false;
  late String error_text = "error";
  var user = User(email: '', password: '');

  Future Function_for_SignUp() async {
    try {
      Map<String, String> data = {
        'email': user.email!,
        'password': user.password!,
        'firstName': user.first_name!,
        'lastName': user.last_name!
      };
      var res = await networkHandler.SimplePost("/create/user", data);
      print(res.statusCode);
      if (res.statusCode == 400) {
        error_text = "all input are required";
      } else if (res.statusCode == 409) {
        error_text = "User Already Exist. Please Login";
      } else {
        setState(() {
          widget.error_exist = false;
        });
      }

      if (res.statusCode != 200) {
        setState(() {
          widget.error_exist = true;
        });
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      print(e);
    }
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
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

  late final Animation<Offset> _animation_fisrt_name = Tween<Offset>(
    begin: const Offset(1, 0.0), // 10 position X axix
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.0,
      0.4,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _animation_last_name = Tween<Offset>(
    begin: const Offset(1.0, 0.0), // 10 position X axix
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.1,
      0.5,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _animation_email = Tween<Offset>(
    begin: const Offset(1.0, 0.0), // 10 position X axix
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.2,
      0.6,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<Offset> _animation_password = Tween<Offset>(
    begin: const Offset(1.0, 0.0), // 10 position X axix
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.3,
      0.7,
      curve: Curves.fastOutSlowIn,
    ),
  ));

  late final Animation<double> _animation_button = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0.1,
      0.7,
      curve: Curves.fastOutSlowIn,
    ),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            child: Text("ERROR ${error_text}"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Register"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.error_exist == true)
              error_widget()
            else
              SizedBox(
                height: 50,
                width: 200,
              ),
            SlideTransition(
              position: _offsetAnimation,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SlideTransition(
              position: _animation_fisrt_name,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, bottom: 16, top: 16),
                child: TextField(
                  controller: TextEditingController(text: user.first_name),
                  onChanged: (value) {
                    user.first_name = value;
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    border: InputBorder.none,
                    icon: Icon(Icons.person),
                    hintText: "First Name",
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _animation_last_name,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, bottom: 16, top: 16),
                child: TextField(
                  controller: TextEditingController(text: user.last_name),
                  onChanged: (value) {
                    user.last_name = value;
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    border: InputBorder.none,
                    icon: Icon(Icons.person),
                    hintText: "Last Name",
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _animation_email,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, bottom: 16, top: 16),
                child: TextField(
                  controller: TextEditingController(text: user.email),
                  onChanged: (value) {
                    user.email = value;
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    border: InputBorder.none,
                    icon: Icon(Icons.email),
                    hintText: "Email",
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _animation_password,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, bottom: 16, top: 16),
                child: TextField(
                  controller: TextEditingController(text: user.email),
                  onChanged: (value) {
                    user.password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 22),
                    border: InputBorder.none,
                    icon: Icon(Icons.lock),
                    hintText: "********",
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: _animation_button,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                height: 58,
                width: 50 +
                    MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height *
                        0.8), // 120 + (200 * _animation.value),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38.0),
                  color: Color(0xFF132137),
                ),
                child: InkWell(
                  onTap: () => Function_for_SignUp(),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.app_registration, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
