import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bantuan"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("Cum detrius potus, omnes triticumes tractare audax, pius exsules."),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("Who can synthesise the happiness and beauty of a source if he has the pure reincarnation of the lotus?"),
            ),
            Text("Cum detrius potus, omnes triticumes tractare audax, pius exsules."),
          ],
        ),
      ),
    );
  }

}