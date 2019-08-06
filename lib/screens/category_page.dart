import 'package:flutter/material.dart';
import 'items_page.dart';
import 'package:flutter_counter/database.dart';
import 'package:flutter_counter/components/TheAlertDialog.dart';



class CategoryPage extends StatefulWidget {
  static const String id = "category_choice";
  @override
  _CategoryPageState createState() => _CategoryPageState();
}



 

class _CategoryPageState extends State<CategoryPage> {
  List<String> list = <String>[];
  String addingText;


  _getAllTablesInit() async {
      DatabaseHelper helper = DatabaseHelper.instance;
      await helper.initDB();
      var tables =  await helper.getTables();
      list = [];
      for (var table in tables){
        list.add(table["name"]);
      }
      print(list);
      setState(() {
        
      });
  }

  _getAllTables() async {
      DatabaseHelper helper = DatabaseHelper.instance;
      var tables =  await helper.getTables();
      list = [];
      for (var table in tables){
        list.add(table["name"]);
      }
      print(list);
      setState(() {
      
      });
  }

  Future<List<String>>_returnTables() async{
      DatabaseHelper helper = DatabaseHelper.instance;
      var tables =  await helper.getTables();
      list = [];
      for (var table in tables){
        list.add(table["name"]);
      }
      return list;
  }

  _addTable(String tableName)async{
    DatabaseHelper helper = DatabaseHelper.instance;
    var currentTables = await _returnTables();
    if (currentTables.contains(tableName)){
      print("Name Already Used");
    }else{
      helper.createTable(tableName);
    }
    _getAllTables();
  }

  TextEditingController _textFieldController = TextEditingController();

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return new TheAlertDialog(
            textFieldController: _textFieldController,
            addingText: addingText,
            titleText: "Add an Item",
            hintText: "Enter Item",
            onPressedAdd: () {
              addingText = _textFieldController.value.text;
              _textFieldController.clear();
              print(addingText);
              _addTable(addingText);
              Navigator.of(context).pop();
              },
            );
        });
  }

  displayEditDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return new TheAlertDialog(
            textFieldController: _textFieldController,
            addingText: addingText,
            titleText: "Edit Name",
            hintText: "Enter Item",
            onPressedAdd: () {
              addingText = _textFieldController.value.text;
              _textFieldController.clear();
              print(addingText);
              _addTable(addingText);
              Navigator.of(context).pop();
              },
            );
        });
  }

  @override
  void initState(){
    super.initState();
    setState(() {
          _getAllTablesInit();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){

            _addTable("Hello");
          },
        ),
      ),
      body: Container(
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          physics: AlwaysScrollableScrollPhysics (),
          padding: EdgeInsets.all(8.0),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(child: Text('${list[index]}')),
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

