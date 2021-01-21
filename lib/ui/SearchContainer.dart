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
      ),
      body: Search.fromServer(_serverModel),
    );
  }
}