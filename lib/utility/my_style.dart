import 'package:flutter/material.dart';

class MyStyle {
  Color darColor = Colors.blue.shade900;
  Color primaryColor = Colors.blue[200];

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 17.0,
          color: Colors.blueAccent.shade400,
          fontWeight: FontWeight.bold,
        ),
      );


  Widget showProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  MyStyle();
}
