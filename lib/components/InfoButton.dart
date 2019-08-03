import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InfoButton extends StatelessWidget {

  InfoButton({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
                title: Text('Choose Options'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text('Read All'),
                    onPressed: onPressed,
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Two'),
                    onPressed: () {
                      Navigator.pop(context, 'Two');
                    },
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                )),
          );
        }
    );
  }
}
