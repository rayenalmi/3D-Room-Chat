import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vcall/Models/User.dart';
import 'package:vcall/NetworkHandler.dart';
import 'package:vcall/home.dart';
import 'package:vcall/start/forget.dart';
import 'package:localstore/localstore.dart';

class Login extends StatefulWidget {
  bool error_exist = false;
  @override
  _LoginState createState() => _LoginState();
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final db = Localstore.instance;
  final storage = new FlutterSecureStorage();
  var networkHandler = NetworkHaundler();
  final bool errorExist = false;
  late String error_text = "error";
  late User user = User(email: '', password: '', first_name: '', last_name: '');
  _LoginState({Key? key, bool? errorExist});

  Future Function_for_Login() async {
    try {
      Map<String, String> data = {
        'email': user.email!,
        'password': user.password!,
      };
      var res = await networkHandler.SimplePost("/login/user", data);

      if (res.statusCode == 400) {
        error_text = "all input are required";
      } else if (res.statusCode == 301) {
        error_text = "this email does not exist ";
      } else if (res.statusCode == 401) {
        error_text = "password is incorrect";
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
        Map data = jsonDecode(res.body);
        //final id = db.collection('users').doc().id;

        // save the item
        //print(data["token"]);
        //db.collection('users').doc().set({'token': data['token']});
        await storage.write(
            key: "token", value: data['token'], aOptions: _getAndroidOptions());
        // tocken here
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
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
    begin: const Offset(1.0, 0.0), // 1.0 = +1 position X axix
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
          child: Text("Login"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
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
                  "Login",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
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
                    icon: Icon(Icons.mail),
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
                  decoration: const InputDecoration(
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
                    (MediaQuery.of(context).size.height * 0.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38.0),
                  color: Color(0xFF132137),
                ),
                child: InkWell(
                  onTap: () {
                    Function_for_Login();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
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
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 30.0,
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: ScaleTransition(
                scale: _animation_button,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Forget())),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Forget ?',
                              style: TextStyle(
                                color: Color(0xff132137),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
