import 'package:flutter/material.dart';
import 'package:note_keeper_new/custom_widget/custom_floating_button.dart';
import 'package:note_keeper_new/utils/database_helper.dart';

import '../models/Note.dart';
import 'add_note.dart';

class NotesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NotesList> {
  List<Note> noteList = [];
  var databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      getAllNoteList();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Keeper App"),
      ),
      body: showNoteList(),
      floatingActionButton: MyFloatingButton(
        onPressed: () {
          gotoEditNoteScreen("Add Note", null);
        },

        /*FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          gotoEditNoteScreen("Add Note", null);
        },*/
      ),
    );
  }

  Widget showNoteList() {
    debugPrint("${noteList.length}");
    var list = ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: _getLeadingIcon(index),
              title: Text(noteList[index].title.toString()),
              subtitle: Text(noteList[index].description.toString()),
              trailing: GestureDetector(
                child: const Icon(Icons.delete),
                onTap: () {
                  if (noteList[index].id != null) {
                    _deleteNote(noteList[index].id!);
                  } else {
                    debugPrint("id is null");
                  }
                },
              ),
              onTap: () {
                gotoEditNoteScreen("Edit Note", noteList[index]);
              },
            ),
          );
        });
    return list;
  }

  void gotoEditNoteScreen(String title, Note? note) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddNote(title, note);
        },
      ),
    );
    debugPrint("$result");
    if (result == true) {
      setState(() {
        getAllNoteList();
      });
    }
  }

  /*void _deleteNote(int index) async{
    var databaseHelper = DatabaseHelper();
    var result =await databaseHelper.insertNote();
  }*/
  void getAllNoteList() async {
    noteList.clear();
    var databaseHelper = DatabaseHelper();
    var futureNoteList = await databaseHelper.getAllNotes();
    List<Note> list = [];

    if (futureNoteList != null) {
      for (var i = 0; i < futureNoteList.length; i++) {
        list.add(Note.fromMapObject(futureNoteList[i]));
      }
    }
    setState(() {
      noteList = list;
    });
  }

  void _deleteNote(int index) async {
    debugPrint("delete note $index");
    var database = databaseHelper.initializeDatabase();
    var result = await databaseHelper.deleteNote(index);
    debugPrint("result is $result");
    setState(() {
      getAllNoteList();
    });
  }

  Widget _getLeadingIcon(int index) {
    Widget widget;
    switch (noteList[index].priority) {
      case 0:
        {
          widget = const CircleAvatar(
            backgroundColor: Colors.yellow,
            child: Icon(Icons.arrow_right),
          );
          break;
        }
      case 1:
        {
          widget = const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.arrow_right),
          );
          break;
        }
      case 2:
        {
          widget = const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.arrow_right),
          );
          break;
        }
      default:
        {
          widget = const CircleAvatar(
            backgroundColor: Colors.yellow,
            child: Icon(Icons.arrow_right),
          );
          break;
        }
    }
    return widget;
  }
}
