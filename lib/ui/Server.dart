import 'dart:convert';
import 'dart:developer';

import 'package:bibliography/helpers/dbhelper_server.dart';
import 'package:bibliography/models/server.dart';
import 'package:bibliography/ui/FormServer.dart';
import 'package:bibliography/ui/SearchContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Server extends StatefulWidget {

  _ServerState __serverState;

  @override
  _ServerState createState() {
    __serverState = _ServerState();
    return __serverState;
  }

  getState() => __serverState;
}

class _ServerState extends State {

  ServerHelper _serverHelper = ServerHelper();
  List<ServerModel> _serverList;
  int count = 0;

  String _selection;

  void refresh() {
    onUpdateListView();
  }

  @override
  Widget build(BuildContext context) {
    if (_serverList == null) {
      _serverList = List<ServerModel>();
      onUpdateListView();
    }

    return Scaffold(
      body: _serverList.length < 1 ? _createEmptyView() : RefreshIndicator(
          child: _createListView(), onRefresh: onUpdateListView),
    );
  }

  ListView _createListView() {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Card(
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightBlue,
            child: Text(_serverList[index].name [0]),
            foregroundColor: Colors.white,
          ),
          title: Text(_serverList[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_serverList[index].url),
              Chip(label: Text(_serverList[index].type))
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String value) async {
              switch(value) {
                case 'search':
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchContainer(_serverList[index]);
                  }));
                  break;
                case 'edit':
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return FormServer(_serverList[index]);
                    }));
                    refresh();
                  break;
                case 'delete':
                    _showMyDialog(_serverList[index]);
                  break;
              }
            },
            child: IconButton(
              icon: Icon(Icons.more_vert_rounded),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'search',
                child: ListTile(
                  leading: Icon(Icons.search, color: Colors.blue,),
                  title: Text('Search collection'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue,),
                  title: Text('Edit'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red,),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchContainer(_serverList[index]);
            }));
          },
        ),
      );
    }, itemCount: count,);
  }

  Future<void> _showMyDialog(ServerModel serverModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Server'),
          content: Text('Are you sure to delete this server?'),
          actions: <Widget>[
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('Cancel')),
            TextButton(onPressed: () async {
              await ServerHelper().delete(serverModel.id);
              Navigator.of(context).pop();
              refresh();
            }, child: Text('Yes, please!'))
          ],
        );;
      },
    );
  }

  Center _createEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/404.png",
            width: 120,
            height: 120,
          ),
          Text('No Server Available'),
          Text('Use add button to add new server')
        ],
      ),
    );
  }

  Future onUpdateListView() async {
    Future<List<ServerModel>> serverList = _serverHelper.getServerList();
    serverList.then((list) {
      setState(() {
        this._serverList = list;
        this.count = _serverList.length;
      });

      // TODO: remove code below if you don't want to add sample server data
      if(list.length < 1) {
        addSampleServer();
      }
    });
  }

  void addSampleServer() async {
    // get json string from file
    String serverJson = await rootBundle.loadString("assets/server.json");
    List<dynamic> serverList = jsonDecode(serverJson);
    for(Map<String,dynamic> server in serverList) {
      ServerModel serverModel = ServerModel.fromMap(server);
      serverModel.id = null;
      ServerHelper serverHelper = ServerHelper();
      await serverHelper.insert(serverModel);
    }
  }
}