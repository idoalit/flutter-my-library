import 'dart:convert';
import 'dart:developer';

import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/models/server.dart';
import 'package:bibliography/ui/DescriptionTextWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

// ignore: must_be_immutable
class SLiMSDetail extends StatefulWidget {
  final String imgTag = 'image_tag';
  final String titleTag = 'title_tag';
  final String authorTag = 'author_tag';

  Biblio biblio;
  ServerModel serverModel;

  SLiMSDetail(this.biblio, this.serverModel);

  @override
  _SLiMSDetailState createState() {
    String url = '${serverModel.url}/?p=show_detail&id=${biblio.id}&inXML=true';
    return _SLiMSDetailState(url, serverModel);
  }
}

class _SLiMSDetailState extends State<SLiMSDetail> {
  Map<String, dynamic> detail;
  String detailURL;
  Biblio biblio;
  ServerModel serverModel;
  String notes = '-';
  DescriptionTextWidget _descriptionTextWidget;

  _SLiMSDetailState(this.detailURL, this.serverModel);

  @override
  void initState() {
    super.initState();
    _getDetail(detailURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: <Widget>[
          _buildImageTitleSection(),
          SizedBox(
            height: 30.0,
          ),
          _buildSectionTitle('Book Description'),
          _buildDivider(),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _descriptionTextWidget),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(height: 30.0),
          _buildSectionTitle('Attachment'),
          _buildDivider(),
          SizedBox(height: 10.0),
          _buildAttachment()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add to collection'),
        icon: Icon(Icons.post_add_rounded),
        onPressed: () => {},
      ),
    );
  }

  _buildImageTitleSection() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: Hero(
              tag: widget.imgTag,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CachedNetworkImage(
                  imageUrl: _getImageUrl(),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,),
                    ),
                  ),
                  placeholder: (context, url) => LinearProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            width: 136.0,
            height: 160.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Hero(
                tag: widget.titleTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    _getTitle(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Hero(
                  tag: widget.authorTag,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      _getAuthors(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey),
                    ),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        '$title',
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _buildDivider() => Divider(
        color: Theme.of(context).textTheme.caption.color,
      );

  _buildAttachment() {

    List<dynamic> digital = _getDigital();

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(digital[index]['\$t']),
            subtitle: Text(digital[index]['path']),
            trailing: Icon(Icons.more_vert_rounded),
          );
        },
        itemCount: digital.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.grey,
        ),
      ),
    );
  }

  void _getDetail(String url) async {
    var client = http.Client();
    var transformer = Xml2Json();

    await client.get(url).then((res) => res.body).then((res) {
      transformer.parse(res);
      var json = transformer.toGData();
      Map<String, dynamic> result = jsonDecode(json);

      String notes = '-';
      if(result['modsCollection']['note'] != null) {
        if(result['modsCollection']['note'].length > 0) {
          if(result['modsCollection']['note'][0]['\$t'] != null) notes = result['modsCollection']['note'][0]['\$t'];
        }
      }

      setState(() {
        this.detail = result;
        this._descriptionTextWidget = DescriptionTextWidget(text: notes);
      });
    });
  }

  String _getTitle() {
    if (detail == null) return '';
    return _itOr(detail['modsCollection']['mods']['titleInfo']['title'], '') +
        ' ' +
        _itOr(detail['modsCollection']['mods']['titleInfo']['subTitle'], '');
  }

  String _getAuthors() {
    if (detail == null) return '';
    var map = detail['modsCollection']['mods'];
    var authors = [];
    for (var i = 0; i < map['name'].length; i++) {
      if (map['name'][i] != null)
        authors.add(map['name'][i]['namePart']['\$t'] ??
            map['name'][i]['namePart']['__cdata']);
    }
    return authors.join(' - ');
  }

  _getImageUrl() {
    var image = serverModel.url + '/images/default/image.png';
    if (detail != null && detail['modsCollection']['slims\$image'] != null)
      image = serverModel.url +
        '/images/docs/' +
        detail['modsCollection']['slims\$image']['\$t'];

    return image;
  }

  List _getDigital() {
    List<dynamic> list = List<dynamic>();
    if(detail == null || detail['modsCollection']['slims\$digitals'] == null) return list;
    var digital = detail['modsCollection']['slims\$digitals']['slims\$digital_item'];
    if(digital is List<dynamic>) {
      list = digital;
    } else {
      if(digital != null ) list.add(digital);
    }
    return list;
  }

  String _itOr(Map map, String _default) {
    if (map == null) return _default;
    return map['\$t'];
  }
}
