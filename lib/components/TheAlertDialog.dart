import 'package:flutter/material.dart';

class TheAlertDialog extends StatelessWidget {

  TheAlertDialog({this.textFieldController,this.addingText,this.onPressedAdd});

  final TextEditingController textFieldController;
  final String addingText;
  Function onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add an Item'),
      content: TextField(
        controller: textFieldController,
        decoration: InputDecoration(hintText: "Enter Item"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            textFieldController.clear();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('ADD'),
          onPressed: onPressedAdd
        ),
      ],
    );
  }
}