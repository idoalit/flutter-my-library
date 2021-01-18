import 'package:bibliography/helpers/dbhelper_server.dart';
import 'package:bibliography/models/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormServer extends StatefulWidget {
  final ServerModel serverModel;
  FormServer(this.serverModel);

  @override
  _FormServerState createState() => _FormServerState(serverModel);
}

class _FormServerState extends State<FormServer> {
  ServerModel serverModel;
  ServerHelper _serverHelper = ServerHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  String _typeController = 'slims';
  var _type = ['slims', 'ucs', 'oai-pmh'];

  _FormServerState(this.serverModel);
  String titlePage = 'Add Server';

  @override
  Widget build(BuildContext context) {
    if (serverModel != null) {
      _typeController = serverModel.type;
      nameController.text = serverModel.name;
      urlController.text = serverModel.url;

      titlePage = 'Edit Server';
    } else {
      serverModel = ServerModel(null);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titlePage),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: _type
                    .map((String e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (String newtype) {
                  _typeController = newtype;
                },
                isDense: true,
                value: _typeController,
              ),
            ),
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
          serverModel.type = _typeController;
          if (serverModel.id != null) {
            await _serverHelper.update(serverModel);
          } else {
            await _serverHelper.insert(serverModel);
          }
          Navigator.pop(context, serverModel);
        },
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
