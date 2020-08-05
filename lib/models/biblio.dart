import 'package:bibliography/models/creator.dart';
import 'package:bibliography/models/subject.dart';

class Biblio {
  int _id;
  String _title;
  String _publisher;
  String _publishYear;
  String _isbn;
  String _synopsis;
  String _authors;
  String _subject;
  String _edition;
  String _type;
  String _notes;
  String _source;

  // constructor
  Biblio(this._id);

  Biblio.fromMap(Map<String, dynamic> map) {
    if (map['id'] is String) {
      this._id = int.parse(map['id']);
    } else {
      this._id = map['id'];
    }
    this._title = map['title'];
    this._publisher = map['publisher'];
    this._publishYear = map['publish_year'];
    this._isbn = map['isbn'];
    this._synopsis = map['description'];
    this._authors = map['creators'];
    this._subject = map['subjects'];
    this._edition = map['edition'];
    this._type = map['type'];
    this._notes = map['notes'];
    this._source = map['source'];
  }

  // getter & setter
  String get subject => _subject;

  set subject(String value) {
    _subject = value;
  }

  String get authors => _authors;

  set authors(String value) {
    _authors = value;
  }

  String get synopsis => _synopsis;

  set synopsis(String value) {
    _synopsis = value;
  }

  String get isbn => _isbn;

  set isbn(String value) {
    _isbn = value;
  }

  String get publishYear => _publishYear;

  set publishYear(String value) {
    _publishYear = value;
  }

  String get publisher => _publisher;

  set publisher(String value) {
    _publisher = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get edition => _edition;

  set edition(String value) {
    _edition = value;
  }

  String get source => _source;

  set source(String value) {
    _source = value;
  }

  String get notes => _notes;

  set notes(String value) {
    _notes = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  // map conversion
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['title'] = title;
    map['publisher'] = publisher;
    map['publish_year'] = publishYear;
    map['isbn'] = isbn;
    map['description'] = synopsis;
    map['creators'] = authors;
    map['subjects'] = subject;
    map['edition'] = edition;
    map['type'] = type;
    map['source'] = source;
    map['notes'] = notes;
    if (this._id == null)
      map['created_at'] = (new DateTime.now()).toIso8601String();
    map['updated_at'] = (new DateTime.now()).toIso8601String();
    return map;
  }
}
