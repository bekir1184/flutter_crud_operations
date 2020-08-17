import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Dikkat"),
      content: Text("Silmek istediginize emin misiniz ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Evet"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text("Hayir"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        )
      ],
    );
  }
}
