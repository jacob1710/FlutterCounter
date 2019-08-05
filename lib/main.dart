import 'package:flutter/material.dart';
import 'screens/category_page.dart';
import 'screens/items_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: CategoryPage(),
      //home: ItemsPage(tableName: "Items"),
    );
  }
}