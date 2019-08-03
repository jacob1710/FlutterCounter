import 'package:flutter/material.dart';
import 'items_page.dart';


class CategoryPage extends StatefulWidget {
  static const String id = "category_choice";
  @override
  _CategoryPageState createState() => _CategoryPageState();
}


class _CategoryPageState extends State<CategoryPage> {
  final List<String> list = <String>["a","b","c","d","e","f"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories"),),
      body: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Center(child: Text('Entry ${list[index]}')),
                onTap: (){
                  print(list[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ItemsPage(tableName: list[index],);
                  }));
                },
              );
            }
        ),
      ),
    );
  }
}

