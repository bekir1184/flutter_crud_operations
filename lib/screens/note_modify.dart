import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_api/models/note.dart';
import 'package:flutter_crud_api/models/note_insert.dart';
import 'package:flutter_crud_api/services/note_services.dart';
import 'package:get_it/get_it.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NoteServices get noteServices => GetIt.I<NoteServices>();

  String errorMessage;

  Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      noteServices.getNote(widget.noteID).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? "Hata var";
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? "Notu Duzenle" : "Not Olustur"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: "Not Basligi"),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(hintText: "Not icerigi"),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          if (isEditing) {
                            //Update
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            final note = NoteInsert(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await noteServices.createNote(note);

                            setState(() {
                              _isLoading = false;
                            });
                            final title = "Bitti";
                            final text = result.error
                                ? (result.errorMessage ??
                                    "Bir hata ile karsilandi")
                                : "Not olusturuldu";

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Tamam"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
        ));
  }
}
