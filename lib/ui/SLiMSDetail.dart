import 'package:bibliography/ui/DescriptionTextWidget.dart';
import 'package:bibliography/ui/SLiMSAttachment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SLiMSDetail extends StatefulWidget {
  final String imgTag = 'image_tag';
  final String titleTag = 'title_tag';
  final String authorTag = 'author_tag';

  @override
  _SLiMSDetailState createState() => _SLiMSDetailState();
}

class _SLiMSDetailState extends State<SLiMSDetail> {
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
            child: DescriptionTextWidget(
                text:
                    'An in-depth examination of the core concepts and general principles of Web application development. This book uses examples from specific technologies (e.g., servlet API or XSL), without promoting or endorsing particular platforms or APIs. Such knowledge is critical when designing and debugging complex systems. This conceptual understanding makes it easier to learn new APIs that arise in the rapidly changing Internet environment'),
          ),
          SizedBox(height: 10.0,),
          SizedBox(height: 30.0),
          _buildSectionTitle('Attachment'),
          _buildDivider(),
          SizedBox(height: 10.0),
          _buildAttachment()
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
              tag: widget.imgTag,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CachedNetworkImage(
                  imageUrl: "https://picsum.photos/200/300?v=3",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.red, BlendMode.colorBurn)),
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
                    'Judul pbuku yang sangat panjang',
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
                      'waris agung widodo',
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
    return Padding(padding: EdgeInsets.all(8.0), child: ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListTile(title: Text('document_1.pdf'), trailing: Icon(Icons.download_rounded),),
        Divider(),
        ListTile(title: Text('document_2.pdf'), trailing: Icon(Icons.download_rounded)),
        Divider(),
        ListTile(title: Text('document_3.pdf'), trailing: Icon(Icons.download_rounded)),
        Divider(),
        ListTile(title: Text('document_4.pdf'), trailing: Icon(Icons.download_rounded)),
        Divider(),
        ListTile(title: Text('document_5.pdf'), trailing: Icon(Icons.download_rounded)),
        Divider(),
        ListTile(title: Text('document_6.pdf'), trailing: Icon(Icons.download_rounded)),
        Divider(),
        ListTile(title: Text('document_7.pdf'), trailing: Icon(Icons.download_rounded)),
      ],
    ),);
  }
}
