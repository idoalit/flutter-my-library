import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/ui/DescriptionTextWidget.dart';
import 'package:bibliography/ui/pdfview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SLiMSDetailLocal extends StatefulWidget {

  Biblio biblio;

  SLiMSDetailLocal(this.biblio);

  @override
  _SLiMSDetailLocalState createState() => _SLiMSDetailLocalState(biblio);

}

// ignore: must_be_immutable
class _SLiMSDetailLocalState extends State<SLiMSDetailLocal> {

  Biblio biblio;
  _SLiMSDetailLocalState(this.biblio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Detail'),
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
          Padding(padding: EdgeInsets.all(8.0), child: DescriptionTextWidget(text: biblio.synopsis)),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(height: 30.0),
          _buildSectionTitle('Attachment'),
          _buildDivider(),
          SizedBox(height: 10.0),
          biblio.link != null ? _buildAttachment() : Padding(padding: EdgeInsets.all(8.0), child: Text('Not found!'),)
        ],
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
              tag: 'tag_image',
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CachedNetworkImage(
                  imageUrl: biblio.image ?? 'https://slims.web.id/demo/images/default/image.png',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
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
                    tag: 'tag_title',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        biblio.title,
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
                      tag: 'tag_author',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          biblio.authors,
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
          color: Colors.blueAccent,
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
    return ListTile(
      title: Text('View Book'),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(biblio.link)));
      },
    );
  }

}