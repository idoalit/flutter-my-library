import 'package:bibliography/models/server.dart';
import 'package:bibliography/ui/Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchContainer extends StatelessWidget {

  ServerModel _serverModel;

  SearchContainer(this._serverModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.deepOrange,
        bottom: MyLinearProgressIndicator(backgroundColor: Colors.white,),
      ),
      body: Search.fromServer(_serverModel),
    );
  }
}

const double _kMyLinearProgressIndicatorHeight = 0.0;

// ignore: must_be_immutable
class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  }) : super(
    key: key,
    value: value,
    backgroundColor: backgroundColor,
    valueColor: valueColor,
  ) {
    preferredSize = Size(double.infinity, _kMyLinearProgressIndicatorHeight);
  }

  @override
  Size preferredSize;
}