import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

// ignore: must_be_immutable
class PdfView extends StatefulWidget {
  URLState _urlState;
  String _link;

  PdfView(String link) {
    _link = link;
  }

  @override
  URLState createState() {
    _urlState =  URLState(_link);
    return _urlState;
  }

  getState() => _urlState;

}

class URLState extends State<PdfView> {

  String link;
  bool _isLoading = true;
  PDFDocument document;

  URLState(this.link);

  @override
  void initState() {
    super.initState();
    loadDocument(link);
  }

  loadDocument(String url) async {
    document = await PDFDocument.fromURL(url);
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