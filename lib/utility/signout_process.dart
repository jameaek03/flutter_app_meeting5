
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/report.dart';

import 'package:flutter_app_meeting/screen/signin.dart';

import 'package:shared_preferences/shared_preferences.dart';

//ออกจากโปรแกรม
Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  //exit(0); ออกจากโปรแกรมเลย
  //สลายสเตทเดิมกับมาหาหน้า home
  MaterialPageRoute route = MaterialPageRoute(
    builder: (context) => SignIn(),
  );
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}






