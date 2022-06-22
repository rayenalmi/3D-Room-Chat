import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  final AnimationController animationController;

  Welcome({Key? key, required this.animationController}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final _introductionanimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.0,
        0.1,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: _introductionanimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width -
                  (MediaQuery.of(context).size.width * 0.2),
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).size.height * 0.6),
              child: Image.asset(
                'assets/img/logo2.png',
                scale: 0.5,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "VCall",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 64, right: 64),
              child: Text(
                "Welcome to Vcall , The application where you can create and participate to meetings.",
                // "Hi our application VCall is a chatroom where you can join/invite people room and you have a 3D model where you see your friend ",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 48,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
              child: InkWell(
                onTap: () {
                  widget.animationController.animateTo(0.7);
                },
                child: Container(
                  height: 58,
                  padding: EdgeInsets.only(
                    left: 56.0,
                    right: 56.0,
                    top: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: Color(0xff132137),
                  ),
                  child: Text(
                    "Let's begin",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
