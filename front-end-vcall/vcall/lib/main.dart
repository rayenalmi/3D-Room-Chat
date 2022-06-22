import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math' as math;

import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:vcall/Scens/Category/Create_Room.dart';
import 'package:vcall/Scens/Room%20Created/Update_Room.dart';
import 'package:vcall/home.dart';
import 'package:vcall/start/begin.dart';
import 'package:vcall/start/login.dart';
import 'package:vcall/start/register.dart';
import 'package:localstore/localstore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VCall',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromRGBO(19, 33, 55, 1),
          ),
          scaffoldBackgroundColor: Color.fromRGBO(247, 235, 225, 1)),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/update_room':
            return PageTransition(
              child: Update_Room(
                id: '',
              ),
              type: PageTransitionType.leftToRightWithFade,
              settings: settings,
              reverseDuration: Duration(seconds: 2),
            );
            break;
          case '/create_room':
            return PageTransition(
              child: Create_Room(),
              type: PageTransitionType.leftToRightWithFade,
              settings: settings,
              reverseDuration: Duration(seconds: 2),
            );
            break;
          case '/sign_up':
            return PageTransition(
              child: Register(),
              type: PageTransitionType.fade,
              settings: settings,
              reverseDuration: Duration(seconds: 2),
            );
            break;
          case '/login':
            return PageTransition(
              child: Login(),
              type: PageTransitionType.fade,
              settings: settings,
              reverseDuration: Duration(seconds: 2),
            );
            break;
          default:
            return null;
        }
      },
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SpinningContainer extends AnimatedWidget {
  const SpinningContainer({
    Key? key,
    required AnimationController controller,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _progress.value * 2.0 * math.pi,
      child: Image.asset(
        'assets/img/loading.png',
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2,
        scale: 0.5,
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  FlutterSecureStorage storage = FlutterSecureStorage();
  late bool logged = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  void TestLogged() async {
    String? token =
        await storage.read(key: "token", aOptions: _getAndroidOptions());
    if (token == null) {
      setState(() {
        logged = false;
      });
    } else {
      setState(() {
        logged = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget GoTO() {
    if (logged == true) {
      return Home();
    } else {
      return const Begin();
    }
  }

  @override
  void initState() {
    TestLogged();
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => GoTO())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xffF7EBE1),
        child: Center(
            child: Column(
          children: [
            Image.asset(
              'assets/img/logo_gris_shadow2.png',
              scale: 0.5,
            ),
            SpinningContainer(controller: _controller),
          ],
        )));
  }
}
