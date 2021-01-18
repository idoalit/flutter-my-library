import 'package:bibliography/models/server.dart';
import 'package:flutter/cupertino.dart';

class ServerViewModel with ChangeNotifier {
  ServerModel serverModel;

  void setServerModel(ServerModel value) {
    serverModel = value;
    notifyListeners();
  }
}