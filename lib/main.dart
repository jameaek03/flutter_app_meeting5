import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/screen/signin.dart';





void main(){
  runApp(
    MaterialApp(
      title: "Find Meeting",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green[600],
          height: 45,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      //home: SignIn(),
      home: SignIn(),
    ),
  );
}