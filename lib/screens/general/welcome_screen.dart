import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merhaba_app/screens/authentication/login_screen.dart';
import 'package:merhaba_app/utils/assets_utils.dart';

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

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      } else {
        setState(() {
          timerStart--;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
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
