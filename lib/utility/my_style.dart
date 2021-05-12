import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStyle {
  Color darColor = Colors.blue.shade900;
  Color primaryColor = Colors.blue[200];

  Text showTitle(String title) => Text(
        title,
        style: GoogleFonts.sarabun(
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
