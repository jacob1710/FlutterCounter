import 'package:flutter/material.dart';

class TheAlertDialog extends StatelessWidget {

  TheAlertDialog({this.textFieldController,this.addingText,this.onPressedAdd,this.titleText,this.hintText,this.addButtonText = "ADD"});

  final TextEditingController textFieldController;
  final String addingText;
  final Function onPressedAdd;
  final String titleText;
  final String hintText;
  final String addButtonText;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: TextField(
        controller: textFieldController,
        decoration: InputDecoration(hintText: hintText),
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
          child: Text(addButtonText),
          onPressed: onPressedAdd
        ),
      ],
    );
  }
}