import 'package:flutter/material.dart';
import "package:page_transition/page_transition.dart";
import 'package:vcall/start/login.dart';
import 'package:vcall/start/register.dart';

class BeforeEnter extends StatelessWidget {
  final AnimationController animationController;
  const BeforeEnter({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.2,
          0.5,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.7,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.2,
        0.5,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _welcomeImageAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.2,
        0.5,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _welcomeButtonToLogin =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.5,
        0.7,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final Animation<double> _animation = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.5,
        0.7,
        curve: Curves.fastOutSlowIn,
      ),
    );

    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              SlideTransition(
                position: _welcomeImageAnimation,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).size.width * 0.3),
                      maxHeight: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.height * 0.6)),
                  child: Image.asset(
                    'assets/img/welcome.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SlideTransition(
                position: _welcomeFirstHalfAnimation,
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, top: 16, bottom: 16),
                child: Text(
                  "Stay organized and professional with Vcall",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                axisAlignment: -1,
                child: Center(
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
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 600),
                              type: PageTransitionType.rightToLeft,
                              child: Login())),
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
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white),
                          ],
                        ),
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
                child: SlideTransition(
                  position: _welcomeButtonToLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create an account?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 600),
                                type: PageTransitionType.rightToLeft,
                                child: Register())),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
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
      ),
    );
  }
}
