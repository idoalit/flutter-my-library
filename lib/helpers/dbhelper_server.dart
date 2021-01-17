import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/server.dart';
import 'package:sqflite/sqflite.dart';

class ServerHelper {

  static ServerHelper _serverHelper;

  ServerHelper._createObject();

  factory ServerHelper() {
    if(_serverHelper == null) _serverHelper = ServerHelper._createObject();
    return _serverHelper;
  }

  Future<int> insert(ServerModel serverModel) async {
    Database database = await DbHelper().database;
    return await database.insert('server', serverModel.toMap());
  }

  Future<int> update(ServerModel serverModel) async {
    Database database = await DbHelper().database;
    return await database.update('server', serverModel.toMap(), where: 'id=?', whereArgs: [serverModel.id]);
  }

  Future<int> delete(int id) async {
    Database database = await DbHelper().database;
    return await database.delete('server', where: 'id=?', whereArgs: [id]);
  }

  Future<List<ServerModel>> getServerList() async {
    Database database = await DbHelper().database;
    var serverMapList = await database.query('server', orderBy: 'created_at DESC');
    List<ServerModel> serverList = List<ServerModel>();
    for(int i = 0; i < serverMapList.length; i++) {
      serverList.add(ServerModel.fromMap(serverMapList[i]));
    }
    return serverList;
  }
}