import 'package:flutter/cupertino.dart';

class Note {
  int? _id;
  String? _title;

  String? _description;
  int? _priority;

  String? _date;

  Note(this._title, this._priority, this._date, [this._description]);

  Note.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

  String? get title => _title;

  String? get date => _date;

  set date(String? value) {
    _date = value;
  }

  int? get priority => _priority;

  set priority(int? value) {
    _priority = value;
  }

  String? get description => _description;

  set description(String? value) {
    _description = value;
  }

  set title(String? value) {
    _title = value;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'] ?? 0;
    _date = map['date'];

    // Note.withId(_id,_title,_priority,_date,_description);
  }
}
