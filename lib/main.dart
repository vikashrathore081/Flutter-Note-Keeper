import 'package:flutter/material.dart';
import 'package:note_keeper_new/screens/note_list.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.lightBlue,
        cardColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red,size: 30,),
        brightness: Brightness.light
      ),
      home: NotesList(),
    );
  }

}
