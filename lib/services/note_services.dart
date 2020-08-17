import 'dart:convert';

import 'package:flutter_crud_api/models/note.dart';
import 'package:flutter_crud_api/models/note_for_listing.dart';
import 'package:flutter_crud_api/models/api_response.dart';
import 'package:flutter_crud_api/models/note_insert.dart';
import 'package:http/http.dart' as http;

class NoteServices {
  static const url = 'http://api.notes.programmingaddict.com';
  static const headers = {
    'apikey': '592d6fa9-c8c2-4b57-b723-fb90ed5e6944',
    'Content-Type':'application/json'    
    };

  Future<APIResponse<List<NoteForListing>>> getNoteList() {
    return http.get(url + '/notes', headers: headers).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        print("burada 0");
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: "Bir hata olustu");
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: "Bir hata olustu q"));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http.get(url + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: "Bir hata olustu");
    }).catchError((_) =>
        APIResponse<Note>(error: true, errorMessage: "Bir hata olustu q"));
  }

  Future<APIResponse<bool>> createNote(NoteInsert item) {
    return http
        .post(url + '/notes', headers: headers, body: jsonEncode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: "Bir hata olustu");
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: "Bir hata olustu q"));
  }
}
