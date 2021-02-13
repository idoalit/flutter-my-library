import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Activation extends StatefulWidget {
  @override
  ActivationState createState() => ActivationState();
}

class ActivationState extends State<Activation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to'),
            Text('My Library'),
            Text('This apps is for research purpose only. Please, enter activation code to use this apps.')
          ],

        ),
      ),
    );
  }
}