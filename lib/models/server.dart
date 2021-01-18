class ServerModel {
  int _id;
  String _name;
  String _url;
  String _type;

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

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  ServerModel.fromMap(Map<String, dynamic> map) {
    if(map['id'] is String) {
      this._id = int.parse(map['id']);
    } else {
      this._id = map['id'];
    }
    this._name = map['name'];
    this._url = map['url'];
    this._type = map['type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = this._name;
    map['url'] = this._url;
    map['type'] = this._type;
    if (this._id == null) map['created_at'] = (DateTime.now()).toIso8601String();
    map['updated_at'] = (DateTime.now()).toIso8601String();
    return map;
  }
}