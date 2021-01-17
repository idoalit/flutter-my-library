import 'package:bibliography/helpers/dbhelper_server.dart';
import 'package:bibliography/models/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormServer extends StatefulWidget {
  @override
  _FormServerState createState() => _FormServerState();
}

class _FormServerState extends State<FormServer> {

  ServerHelper _serverHelper = ServerHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ServerModel serverModel = ServerModel(null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Server'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    labelText: 'URL',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_rounded),
        onPressed: () async {
          serverModel.name = nameController.text.trim();
          serverModel.url = urlController.text.trim();
          var insert = await _serverHelper.insert(serverModel);
          Navigator.pop(context, serverModel);
        },
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}