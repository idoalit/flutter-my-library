import 'dart:convert';

import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/ui/entryform.dart';
import 'package:bibliography/ui/pdfview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {

  _HomeState __homeState;

  @override
  _HomeState createState() {
    __homeState = _HomeState();
    return __homeState;
  }

  getState() => __homeState;
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
      body: biblioList.length < 1
          ? emptyView()
          : RefreshIndicator(
              onRefresh: updateListView,
              child: createListView(),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var biblio = await navigateToEntryForm(context, null);
      //     if (biblio != null && biblio.title != '') saveBiblio(biblio);
      //   },
      //   child: const Icon(Icons.add),
      //   backgroundColor: Colors.pinkAccent,
      // ),
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
    // ignore: deprecated_member_use
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {

        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: this.biblioList[index].image != null ? null : Text(this.biblioList[index].title[0]),
              foregroundColor: Colors.white,
              backgroundImage: this.biblioList[index].image != null ? NetworkImage(this.biblioList[index].image) : null,
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
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0))),
                  context: context,
                  builder: (BuildContext buildContex) {
                    Biblio biblio = this.biblioList[index];
                    List<String> subjects = biblio.subject != null ?
                        biblio.subject.split(',')
                        .map((String s) => s.trim())
                        .toList() : List<String>();

                    return FractionallySizedBox(
                      heightFactor: 0.8,
                      child: Stack(
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0,
                                  top: 32.0,
                                  right: 16.0,
                                  bottom: 16.0),
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
                                    padding:
                                        EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Text(
                                      '${String.fromCharCode(0x2014)} ${biblio.authors}',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  Text(
                                    biblio.synopsis ?? '-',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Edition: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(biblio.edition ?? '')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'ISBN: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(biblio.publishYear)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: Tags(
                                      itemCount: subjects.length,
                                      itemBuilder: (int index) {
                                        return ItemTags(
                                          title: subjects[index],
                                          index: index,
                                          elevation: 0.0,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0))),
                            height: 24,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0))),
                                  width: 80,
                                  height: 8,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(1.0, 0.0),
                                        blurRadius: 6.0)
                                  ]),
                              width: MediaQuery.of(context).size.width,
                              child: ButtonBar(
                                children: <Widget>[
                                  Conditional.single(
                                      context: context,
                                      conditionBuilder: (BuildContext context) => biblio.link != null,
                                      widgetBuilder: (BuildContext context) => FlatButton(
                                        textColor: Colors.grey,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.book),
                                            Text('View book')
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            if (biblio.path != null) return PdfView.fromPath(biblio.path);
                                            return PdfView(biblio.link);
                                          }));
                                        },
                                      ),
                                      fallbackBuilder: (BuildContext context) => Text('')),
                                  FlatButton(
                                    textColor: Colors.grey,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.delete),
                                        Text('Delete')
                                      ],
                                    ),
                                    onPressed: () {
                                      showAlertDialog(context, biblio);
                                    },
                                  ),
                                  RaisedButton(
                                    color: Colors.blueAccent,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.edit),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text('Edit'),
                                        )
                                      ],
                                    ),
                                    onPressed: () async {
                                      var mBiblio = await navigateToEntryForm(
                                          context, biblio);
                                      if (mBiblio != null &&
                                          mBiblio.title != '')
                                        updateBiblio(mBiblio);
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
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

  void updateBiblio(Biblio biblio) async {
    int result = await dbHelper.update(biblio);
    if (result > 0) {
      updateListView();
    }
  }

  Future updateListView() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Biblio>> biblioListFuture = dbHelper.getBiblioList();
      biblioListFuture.then((biblioList) {
        setState(() {
          this.biblioList = biblioList;
          this.count = biblioList.length;

          if (biblioList.length < 1) {
            // Todo: REMOVE THIS CODE IN PRODUCTION
            // createSampleData();
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

  void showAlertDialog(BuildContext context, Biblio biblio) async {
    AlertDialog alert = AlertDialog(
      title: Text('Alert'),
      content: Text('Are you sure to delete this title - ${biblio.title}?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: Colors.grey,
        ),
        FlatButton(
          child: Text('Yes, delete it'),
          onPressed: () async {
            int result = await dbHelper.delete(biblio.id);
            if (result > 0) {
              updateListView();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${biblio.title} deleted'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Unable to delete ${biblio.title}',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ));
            }
            Navigator.pop(context);
          },
        )
      ],
    );

    await showDialog(context: context, builder: (context) => alert)
        .then((value) {
      Navigator.of(context).pop();
    });
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

Future<List<Biblio>> searchBiblio(String keywords) async {
  DbHelper dbHelper = DbHelper();
  return dbHelper.getBiblioSearch(keywords);
}

class BibliographySearch extends SearchDelegate {
  DbHelper dbHelper = DbHelper();

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
    DbHelper dbHelper = DbHelper();

    return FutureBuilder(
      future: searchBiblio(query),
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.only(top: 16.0),
          child: snapshot.hasData && snapshot.data.length > 0
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    Biblio biblio = snapshot.data[index];

                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(biblio.title),
                      ),
                      onTap: () async {
                        Biblio mBiblio =
                            await navigateToEntryForm(context, biblio);
                        if (mBiblio != null && mBiblio.title != '') {
                          await dbHelper.update(mBiblio);
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                  itemCount: snapshot.data.length)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        "assets/not-found.png",
                        width: 100,
                        height: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text('No Data Found!'),
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              "assets/check-mark.png",
              width: 100,
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Enter some keywords to search'),
            )
          ],
        ),
      ),
    );
  }
}
