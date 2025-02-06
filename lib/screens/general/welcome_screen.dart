import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
import 'package:merhaba_app/screens/authentication/login_screen.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Timer? timer;
  int timerStart = 2;

  startTimer() {
    timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      if (timerStart == 0) {
        timer.cancel();

        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return LoginScreen();
        // }));
        Navigator.of(context).pushNamed("/login");
      } else {
        setState(() {
          timerStart--;
        });
      }
    });
  }

  Future<void> checkLogin() async {
    try {
      var res = await AuthController.checkLogin();
      if (res["result"] == true) {
        final timelineProvider = Provider.of<TimelineProvider>(
          context,
        );

        timelineProvider.getData();

        Navigator.of(context).pushNamed("/home");
      } else {
        Navigator.of(context).pushNamed("/login");
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).pushNamed("/login");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // startTimer();
    checkLogin();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AssetsUtils.appIconLight,
          // width: (MediaQuery.sizeOf(context).width - 60) * 0.5,
        ),
      ),
    );
  }
}
