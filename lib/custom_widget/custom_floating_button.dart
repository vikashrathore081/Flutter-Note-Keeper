import 'package:flutter/material.dart';

class MyFloatingButton extends StatelessWidget{

  final GestureTapCallback onPressed;

  const MyFloatingButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        child: Column(
          children: const [
            Icon(Icons.add,color: Colors.white,size: 30,),
            Text("Add",style: TextStyle(color: Colors.white),)
          ],
        ),
        radius: 35,
      ),
      onTap: onPressed,
    );
  }

}