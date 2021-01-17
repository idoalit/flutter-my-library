class ServerModel {
  int _id;
  String _name;
  String _url;

  ServerModel(this._id);

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  ServerModel.fromMap(Map<String, dynamic> map) {
    if(map['id'] is String) {
      this._id = int.parse(map['id']);
    } else {
      this._id = map['id'];
    }
    this._name = map['name'];
    this._url = map['url'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = this._name;
    map['url'] = this._url;
    if (this._id == null) map['created_at'] = (DateTime.now()).toIso8601String();
    map['updated_at'] = (DateTime.now()).toIso8601String();
    return map;
  }
}