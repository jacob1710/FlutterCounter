// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

final String tableItems = 'items';
final String columnId = '_id';
final String columnName = 'name';
final String columnNumber = 'number';

class Item {
  int id;
  String name;
  int number;

  Item({
    this.id,
    this.name,
    this.number,
  });

  Item.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    number = map[columnNumber];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnNumber: number
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
