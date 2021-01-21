import 'dart:convert';

import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/models/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isLoading = false;

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
              child: _biblioList.length < 1
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _isLoading ? const CircularProgressIndicator() :
                          Image.asset(
                            "assets/not-found.png",
                            width: 80,
                            height: 80,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(_isLoading ? 'Loading...' : 'Data not found!'),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Card(
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

    setState(() {
      this._isLoading = true;
    });

    if (_serverModel != null) {
      // search to server
      switch (_serverModel.type) {
        case 'slims':
          {
            var url = "${_serverModel.url}?resultXML=true&keywords=$keyword&search=search";
            xmlToJson(url);
          }
          break;
        case 'ucs':
          {
            print(xmlToJson(keyword));
          }
          break;
      }
    } else {
      // search local
      DbHelper dbHelper = DbHelper();
      // query
      List<Biblio> resultList = await dbHelper.getBiblioSearch(keyword);
      setState(() {
        this._biblioList = resultList;
        this._isLoading = false;
      });
    }
  }

  Future<String> xmlToJson(String url) async {
    var client = new http.Client();
    final myTransformer = Xml2Json();
    return await client
        .get(url)
        .then((response) {
      return response.body;
    }).then((bodyString) {
      myTransformer.parse(bodyString);
      var json = myTransformer.toGData();
      List<Biblio> resultList = List<Biblio>();
      Map<String, dynamic> result = jsonDecode(json);

      for (var i = 0; i < result['modsCollection']['mods'].length; i++) {
        if (result['modsCollection']['mods'][i] != null)
          resultList.add(Biblio.fromSLiMS(result['modsCollection']['mods'][i]));
      }
      setState(() {
        this._biblioList = resultList;
        this._isLoading = false;
      });
      return json;
    }).catchError((error) {
      // Fluttertoast.showToast(
      //     msg: error.toString(),
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.SNACKBAR,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      print(url);
      print(error);
      setState(() {
        this._biblioList = List<Biblio>();
        this._isLoading = false;
      });
    });
  }
}
