import 'package:flutter/material.dart';
import 'items_page.dart';
import 'package:flutter_counter/database.dart';
import 'package:flutter_counter/components/TheAlertDialog.dart';
import 'package:flutter_counter/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';




class CategoryPage extends StatefulWidget {
  static const String id = "category_choice";
  @override
  _CategoryPageState createState() => _CategoryPageState();
}



 

class _CategoryPageState extends State<CategoryPage> {
  List<String> list = <String>[];
  String addingText;


  void _deleteTable(String tableName)async{
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteTable(tableName);
    _getAllTables();
  }


  void _getAllTablesInit() async {
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

  void _getAllTables() async {
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

  void _addTable(String tableName)async{
    DatabaseHelper helper = DatabaseHelper.instance;
    var currentTables = await _returnTables();
    if (currentTables.contains(tableName)){
      print("Name Already Used");
    }else{
      helper.createTable(tableName);
    }
    _getAllTables();
  }

  Future<int> _changeTableName(String oldTableName,String newTableName)async{
    int errorCode = 200;
    DatabaseHelper helper = DatabaseHelper.instance;
    var currentTables = await _returnTables();
    if (currentTables.contains(newTableName)){
      print("Name in use");
      errorCode = 409;
    }else if(kNotAllowedNames.contains(newTableName)){
      print("Name not allowed");
      errorCode = 406;
    }else{
      helper.updateTableName(oldTableName, newTableName);
    }
    _getAllTables();
    return errorCode;
  }

  TextEditingController _textFieldController = TextEditingController();


  void _showErrorDialog(String errorName) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorName),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _displayAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return TheAlertDialog(
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

  _displayEditDialog(BuildContext context,String currentTableName) async {
    return showDialog(
        context: context,
        builder: (context) {
          return new TheAlertDialog(
            textFieldController: _textFieldController,
            addingText: addingText,
            titleText: "Edit Name: $currentTableName",
            hintText: "Enter Category Name",
            addButtonText: "EDIT",
            onPressedAdd: () async {
              addingText = _textFieldController.value.text;
              _textFieldController.clear();
              print(addingText);
              var returnCode = await _changeTableName(currentTableName, addingText);
              Navigator.of(context).pop();
              if (returnCode != 200){
                _showErrorDialog("Couldn't change name: ${kNameErrorCodes[returnCode]}");
              }
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Categories"),
            centerTitle: true,
            floating: false,
            primary: true,
            expandedHeight: 80.0,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.add), onPressed: (){
                _displayAddDialog(context);
               }),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Slidable(
                    actionExtentRatio: 0.25,
                    closeOnScroll: true,
                    actionPane: SlidableStrechActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          print(list[index]);
                          _deleteTable(list[index]);
                        },
                      ),
                    ],
                    child: Container(
                      color: index %2 == 0 ? Colors.grey[100]:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            title: Center(child: Text('${list[index]}')),
                            onLongPress: (){
                              _displayEditDialog(context,list[index]);
                            },
                            onTap: (){
                              print(list[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ItemsPage(tableName: list[index],);
                              }));
                            },
                          ),
                      ),
                    ),
                  ),
              childCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
}

