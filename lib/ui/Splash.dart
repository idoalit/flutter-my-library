import 'dart:async';

import 'package:bibliography/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  StateSplashScreen _stateSplashScreen;

  @override
  State<StatefulWidget> createState() {
    _stateSplashScreen = StateSplashScreen();
    return _stateSplashScreen;
  }

  getState() => _stateSplashScreen;

}

class StateSplashScreen extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      return Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/logo.png"),
              Image.asset("assets/box.png", width: 50, height: 50,),
              Padding(padding: EdgeInsets.all(16), child: Text("v.1.0.0-dev"),)
            ],
          ),
        )
    );
  }

}