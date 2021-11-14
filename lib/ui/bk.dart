import 'dart:convert';

import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/ui/entryform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  List<Biblio> biblioList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (biblioList == null) {
      biblioList = List<Biblio>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Library'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () {
              showSearch(context: context, delegate: BibliographySearch());
            },
          )
        ],
      ),
      body: biblioList.length < 1 ? emptyView() : createListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var biblio = await navigateToEntryForm(context, null);
          if (biblio != null && biblio.title != '') saveBiblio(biblio);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  Center emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/box.png",
            width: 100,
            height: 100,
          ),
          Text('Empty Data')
        ],
      ),
    );
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text(this.biblioList[index].title[0]),
              foregroundColor: Colors.white,
            ),
            title: Text(
              this.biblioList[index].title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              this.biblioList[index].authors,
              overflow: TextOverflow.ellipsis,
            ),
//            trailing: GestureDetector(
//              child: Icon(Icons.delete),
//              onTap: () {
//                Scaffold.of(context).showSnackBar(SnackBar(
//                  content: Text(this.biblioList[index].title + ' deleted'),
//                  duration: Duration(seconds: 1),
//                ));
//              },
//            ),
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0))),
                  context: context,
                  builder: (BuildContext buildContex) {
                    Biblio biblio = this.biblioList[index];
                    List<String> subjects = biblio.subject
                        .split(',')
                        .map((String s) => s.trim())
                        .toList();

                    return SafeArea(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, top: 24.0, right: 16.0, bottom: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                biblio.title,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Text(
                                  '${String.fromCharCode(0x2014)} ${biblio.authors}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Text(
                                biblio.synopsis,
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'ISBN: ',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(biblio.isbn)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Publisher: ',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(biblio.publisher)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Publish Year: ',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(biblio.publishYear)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Tags(
                                  itemCount: subjects.length,
                                  itemBuilder: (int index) {
                                    return ItemTags(
                                      title: subjects[index],
                                      index: index,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        );
      },
      itemCount: count,
    );
  }

  void saveBiblio(Biblio biblio) async {
    int result = await dbHelper.insert(biblio);
    if (result > 0) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Biblio>> biblioListFuture = dbHelper.getBiblioList();
      biblioListFuture.then((biblioList) {
        setState(() {
          this.biblioList = biblioList;
          this.count = biblioList.length;

          if (biblioList.length < 1) {
            // Todo: REMOVE THIS CODE IN PRODUCTION
            createSampleData();
          }
        });
      });
    });
  }

  void createSampleData() async {
    List<dynamic> json = await _loadSampleData();
    for (Map<String, dynamic> s in json) {
      Biblio b = Biblio.fromMap(s);
      b.id = null;
      await dbHelper.insert(b);
    }
    updateListView();
  }
}

Future<String> _loadJson() async {
  return await rootBundle.loadString("assets/sample.json");
}

Future _loadSampleData() async {
  String source = await _loadJson();
  List<dynamic> jsonResponse = jsonDecode(source);
  return jsonResponse;
}

Future<Biblio> navigateToEntryForm(BuildContext context, Biblio biblio) async {
  var result = await Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
        return EntryForm(biblio);
      }));
  return result;
}

class BibliographySearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
