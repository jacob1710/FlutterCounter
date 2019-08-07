import 'package:flutter/material.dart';
import 'package:flutter_counter/database.dart';
import 'package:flutter_counter/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_counter/components/TheAlertDialog.dart';
import 'package:flutter_counter/constants.dart';
import 'package:flutter_counter/components/ShowErrorDialog.dart';



class ItemsPage extends StatefulWidget {
  static const String id = "items_page";

  final String tableName;

  ItemsPage({this.tableName});

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {

  String addingText;

  List<Item> itemList = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper helper = DatabaseHelper.instance;
    helper.initDatabase();
    _readAll();
  }

  TextEditingController _textFieldController = TextEditingController();

  void _displayAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return new TheAlertDialog(
            textFieldController: _textFieldController,
            addingText: addingText,
            titleText: 'Add an Item',
            hintText: "Enter Item",
            onPressedAdd: () {
              addingText = _textFieldController.value.text;
              _textFieldController.clear();
              print(addingText);
              _addItem(addingText, 0);
              Navigator.of(context).pop();
              },
            );
        });
  }
  void _displayEditDialog(BuildContext context, Item item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return new TheAlertDialog(
            textFieldController: _textFieldController,
            addingText: addingText,
            titleText: 'Edit Name',
            hintText: "Enter New Name",
            onPressedAdd: () async{
              addingText = _textFieldController.value.text;
              _textFieldController.clear();
              print(addingText);
              //Validation
              _changeItemName(item, addingText);
              Navigator.of(context).pop();
              },
            );
        });
  }

  void _changeItemName(Item item, String textToUpdate)async{
    DatabaseHelper helper = DatabaseHelper.instance;
    item.name = textToUpdate;
    await helper.update(item,widget.tableName);
    setState(() {});
  }

  void _readAll() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    itemList = await helper.queryAllItems(widget.tableName);
    setState(() {});
    for (var item in itemList) {
      print("Item = ID:${item.id}, Name:${item.name}, Number:${item.number}");
    }
  }

  void _update(Item item) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.update(item,widget.tableName);
    setState(() {});
  }

  void _delete(Item item) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    helper.delete(item.id,widget.tableName);
  }


  void _addItem(name, number) async {
    Item item = Item();
    item.name = name;
    item.number = number;
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(item,widget.tableName);
    print('inserted row: $id');
    _readAll();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(widget.tableName),
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
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Reset',
                        foregroundColor: Colors.white,
                        color: Colors.grey,
                        icon: Icons.undo,
                        onTap: () {
                          print(itemList[index]);
                          setState(() {
                            itemList[index].number = 0;
                            _update(itemList[index]);
                          });
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          print(itemList[index]);
                          _delete(itemList[index]);
                          setState(() {
                            _readAll();
                          });
                        },
                      ),
                      IconSlideAction(
                        caption: 'Take Away 1',
                        foregroundColor: Colors.white,
                        color: Colors.grey,
                        icon: Icons.arrow_back,
                        onTap: () {
                          print(itemList[index]);
                          setState(() {
                            itemList[index].number--;
                            _update(itemList[index]);
                          });
                        },
                      ),
                    ],
                    child: Container(
                      color: index %2 == 0 ? Colors.grey[100]:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onLongPress: (){
                            _displayEditDialog(context,itemList[index]);
                            },
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigoAccent,
                            child: Text(
                                '${itemList[index].number}',
                            ),
                            foregroundColor: Colors.white,
                          ),
                          title:Text('${itemList[index].name}',style: TextStyle(color: Colors.black)),
                          trailing: new RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                itemList[index].number++;
                                _update(itemList[index]);
                              });
                            },
                            child: new Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 25.0,
                            ),
                            shape: new CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
              childCount: itemList.length,
            ),
          ),
        ],
      ),
    );
  }
}

