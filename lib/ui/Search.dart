import 'dart:convert';

import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/models/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  ServerModel _serverModel;

  Search();

  Search.fromServer(this._serverModel);

  @override
  _SearchState createState() {
    if (_serverModel == null) {
      return _SearchState();
    } else {
      return _SearchState.serverModel(_serverModel);
    }
  }
}

class _SearchState extends State<Search> {
  TextEditingController keyworldController = TextEditingController();
  List<Biblio> _biblioList;
  ServerModel _serverModel;

  _SearchState();

  _SearchState.serverModel(this._serverModel);

  @override
  Widget build(BuildContext context) {
    if (_biblioList == null) {
      _biblioList = List<Biblio>();
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Colors.deepOrange.withOpacity(0.23),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onSubmitted: _onSubmited,
                    controller: keyworldController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: _serverModel != null
                          ? 'Search in ${_serverModel.name}'
                          : 'Search',
                      hintStyle: TextStyle(
                        color: Colors.deepOrange.withOpacity(0.5),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.search_rounded),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.book_outlined),
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(
                    _biblioList[index].title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_biblioList[index].authors),
                  onTap: () => {},
                  isThreeLine: true,
                ),
              );
            },
            itemCount: _biblioList.length,
          ))
        ],
      ),
    );
  }

  void _onSubmited(String keyword) async {
    DbHelper dbHelper = DbHelper();
    // query
    List<Biblio> resultList = await dbHelper.getBiblioSearch(keyword);
    setState(() {
      this._biblioList = resultList;
    });

    print(rssToJson());
  }

  Future<String> rssToJson() async {
    var client = new http.Client();
    final myTransformer = Xml2Json();
    return await client
        .get("https://slims.web.id/demo/index.php?resultXML=true&keywords=&search=search")
        .then((response) {
      return response.body;
    }).then((bodyString) {
      myTransformer.parse(bodyString);
      var json = myTransformer.toGData();

      print(json);

      return json;
    });
  }
}