import 'package:flutter/material.dart';
import 'package:vcall/start/before_enter.dart';
import 'package:vcall/start/welcome.dart';

class Begin extends StatefulWidget {
  const Begin({Key? key}) : super(key: key);

  @override
  _BeginState createState() => _BeginState();
}

class _BeginState extends State<Begin> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController?.animateTo(0.0);

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7EBE1),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Welcome(
              animationController: _animationController!,
            ),
            BeforeEnter(animationController: _animationController!),
          ],
        ),
      ),
    );
  }
}
