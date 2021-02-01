import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

// ignore: must_be_immutable
class PdfView extends StatefulWidget {
  URLState _urlState;
  String _link;
  String _path;

  PdfView(String link) {
    _link = link;
  }

  PdfView.fromPath(String path) {
    _path = path;
  }

  @override
  URLState createState() {
    _urlState =  URLState(_link, _path);
    return _urlState;
  }

  getState() => _urlState;

}

class URLState extends State<PdfView> {

  String link;
  String path;
  bool _isLoading = true;
  PDFDocument document;

  URLState(this.link, this.path);

  @override
  void initState() {
    super.initState();
    if (path != null) {
      loadDocumentLocal(path);
    } else {
      loadDocument(link);
    }
  }

  loadDocument(String url) async {
    document = await PDFDocument.fromURL(url);
    setState(() => _isLoading = false);
  }

  loadDocumentLocal(String path) async {
    document = await PDFDocument.fromAsset(path);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Read Book'),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );

  }
}