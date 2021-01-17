import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              "assets/coming-soon.png",
              width: 100,
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Under development'),
            ),
          ],
        ),
      ),
    );
  }

}