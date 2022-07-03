import 'package:flutter/material.dart';
import 'package:note_keeper_new/models/Note.dart';
import 'package:note_keeper_new/utils/database_helper.dart';

class AddNote extends StatefulWidget {
  String title = "";
  Note? note;

  AddNote(this.title, this.note);

  @override
  State<StatefulWidget> createState() {
    return _AddNote(this.title, this.note);
  }
}

class _AddNote extends State<AddNote> {
  var priorities = ['low', 'medium', 'high'];
  var selectedItem = 'low';
  var titleController = TextEditingController();
  var desController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String title = "";
  Note? note;
  String mode = "Save";
  bool isValueSet = false;

  _AddNote(this.title, this.note);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (note != null && !this.isValueSet) {
      setState(() {
        mode = "Update";
        _setData();
        this.isValueSet = !this.isValueSet;
      });
    }
    return WillPopScope(
      onWillPop: () async {
        backPressed();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              backPressed();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                DropdownButton<String>(
                  items: priorities.map(
                    (String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      debugPrint("selected item $value");
                      selectedItem = value!;
                    });
                  },
                  value: selectedItem,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                      ),
                      hintText: "Enter Note title",
                      labelText: "Title",
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "Please enter title";
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: desController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                      ),
                      hintText: "Enter Note description",
                      labelText: "Description",
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "Please enter description";
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 40,
                          child: ElevatedButton(
                            child: Text(mode),
                            onPressed: () {
                              if (note == null) {
                                saveData();
                              } else {
                                updateNoteData();
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: ElevatedButton(
                            child: const Text("Reset"),
                            onPressed: () {
                              _resetViews();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveData() async {
    if (formKey.currentState?.validate() == true) {
      var date = DateTime.now();
      var priority = 0;
      priority = getPriority(selectedItem);
      debugPrint(
          "drop: $selectedItem \ntitle : ${titleController.text} \ndes: ${desController.text} ");
      var note = Note(
          titleController.text, priority, date.toString(), desController.text);
      var databaseHelper = DatabaseHelper();
      // var database = await databaseHelper.database;
      var result = await databaseHelper.insertNote(note);
      debugPrint("$result");
      if (result != null && result >= 0) {
        setState(() {
          debugPrint("Note Added successfully");
          showSnackBar("Note Added successfully");

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true);
          });
        });
      }
    }
  }

  void updateNoteData() async {
    var priority = 0;
    priority = getPriority(selectedItem);
    var databaseHelper = DatabaseHelper();
    var note = Note(titleController.text, priority, null, desController.text);
    note.id = this.note?.id;
    note.date = this.note?.date;
    var result = await databaseHelper.updateNote(note);
    debugPrint("$result");
    if (result != null && result >= 1) {
      showSnackBar("Note updated");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    }
  }

  void showSnackBar(title) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(title)));
  }

  void backPressed() {
    Navigator.pop(context, true);
  }

  int getPriority(String selectedItem) {
    var priority = 0;
    switch (selectedItem) {
      case "low":
        {
          priority = 0;
          break;
        }
      case "medium":
        {
          priority = 1;
          break;
        }
      case "high":
        {
          priority = 2;
          break;
        }
      default:
        {
          priority = 0;
          break;
        }
    }
    return priority;
  }

  void _setData() {
    debugPrint("${note?.priority}");
    switch (note?.priority) {
      case 0:
        {
          selectedItem = priorities[0];
          break;
        }
      case 1:
        {
          selectedItem = priorities[1];
          break;
        }
      case 2:
        {
          selectedItem = priorities[2];
          break;
        }
    }
    if (note?.title != null) {
      titleController.text = note!.title!;
    }
    if (note?.description != null) {
      desController.text = note!.description!;
    }
  }

  void _resetViews() {
    setState(() {
      debugPrint("reset view");
      selectedItem = priorities[0];
      titleController.text = '';
      desController.text = '';
    });
  }
}
