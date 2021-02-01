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
  String _link;
  String _image;
  String _path;

  // constructor
  Biblio(this._id);

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

  String get link => _link;

  set link(String value) {
    _link = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  String get path => _path;

  set path(String value) {
    _path = value;

  } // map conversion
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
    map['link'] = link;
    map['image'] = image;
    map['path'] = path;
    if (this._id == null)
      map['created_at'] = (new DateTime.now()).toIso8601String();
    map['updated_at'] = (new DateTime.now()).toIso8601String();
    return map;
  }

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
    this._link = map['link'];
    this._image = map['image'];
    this._path = map['path'];
  }

  Biblio.fromSLiMS(Map<String, dynamic> map) {
    this._id = map['ID'] != null ? int.parse(map['ID']) : null;
    // var subtitle = (map['titleInfo']['subTitle'] != null) ? (map['titleInfo']['subTitle']['\$t'] ?? map['titleInfo']['subTitle']['__cdata']) : '';
    var subtitle = _getValue(map, 'titleInfo.subTitle', '');
    this._title = _getValue(map, 'titleInfo.title', '-') + ' ' + subtitle;

    if (map['originInfo']['place']['publisher'] != null) {
      // result search
      this._publisher = _getValue(map, 'originInfo.place.publisher', '-');
      this._publishYear = _getValue(map, 'originInfo.place.dateIssued', '-');
    } else {
      // result detail
      this._publisher = _getValue(map, 'originInfo.publisher', '-');
      this._publishYear = _getValue(map, 'originInfo.dateIssued', '-');
    }

    this._isbn = _getValue(map, 'identifier', '-');

    var authors = [];
    for(var i = 0; i < map['name'].length; i++) {
      if(map['name'][i] != null) authors.add(map['name'][i]['namePart']['\$t'] ?? map['name'][i]['namePart']['__cdata']);
    }
    this._authors = authors.join(' - ');

    if (map['subject'] != null ) {
      var subjects = [];
      for(var i = 0; i < map['subject'].length; i++) {
        if(map['subject'][i] != null) subjects.add(map['subject'][i]['topic']['\$t'] ?? map['subject'][i]['topic']['__cdata']);
      }
      this._subject = subjects.join(' - ');
    }

    if (map['note'] != null) {
      if (map['note'].length > 0) {
        if (map['note'][0] != null) {
          this._synopsis = map['note'][0]['\$t'];
        } else {
          this._synopsis = map['note']['\$t'];
        }
      }
    }

    // default type as book
    this._type = 'Book';

    if(map['slims\$image'] != null) {
      this._image = map['slims\$image']['\$t'];
    } else if(map['image'] != null) {
      this._image = map['image']['__cdata'];
    }
  }

  _getValue(Map<String, dynamic> map, String dotKeys, String _default) {
    List<dynamic> keys = dotKeys.split('.').toList();

    Map<String, dynamic> tmp;
    String value;
    for(var i = 0; i < keys.length; i++) {

      if (i < 1 && map[keys[i]] is! String) {
        tmp = map[keys[i]];
        continue;
      }

      if(tmp[keys[i]] != null && tmp[keys[i]] is! String) {
        tmp = tmp[keys[i]];
      }
    }



    if(tmp['\$t'] != null) {
      value = tmp['\$t'];
    } else if (tmp['__cdata'] != null) {
      value = tmp['__cdata'];
    } else {
      value = _default;
    }

    return value;
  }
}
