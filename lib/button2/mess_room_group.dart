import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/show_mess.dart';
import 'package:flutter_app_meeting/button2/show_mess_group.dart';
import 'package:flutter_app_meeting/model/group_model.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessRoomGroup extends StatefulWidget {
  final GroupModel groupModel;

  MessRoomGroup({Key key, this.groupModel}) : super(key: key);

  @override
  _MessRoomGroupState createState() => _MessRoomGroupState();
}

class _MessRoomGroupState extends State<MessRoomGroup> {
  GroupModel groupModel;
  String r_name, m_mess, r_id;

  List<GroupModel> groupModels = List();

  List<Widget> roomCards = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupModel = widget.groupModel;
    r_name = groupModel.rName;
    r_id = groupModel.rId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: roomMessage(),
      appBar: AppBar(
        title: Text('แชท ${groupModel.rName}',style: GoogleFonts.sarabun()),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 400.0,
                height: 280.0,
                child: Image.network(
                  '${MyDomain().domain}${groupModel.rImg}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                messForm(),
                SizedBox(
                  width: 20.0,
                ),
                send(),
              ],
            ),
          ],
        ),
      ),
    );
  }



  //-----------------------------------------------------------------
  //บันทึกข้อมูลขึ้น database
  Future<Null> insertReport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String u_id = preferences.getString('id');

    String url = '${MyDomain().domain}/Meeting/messageInsert.php?isAdd=true&u_id=$u_id&m_mess=$m_mess&r_id=$r_id';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        //Navigator.pop(context);
      } else {
        normalDialog(context, 'สำเร็จ');
      }
    });
  }

  //ส่งข้อมูล
  Widget send() {
    return Container(
      height: 60,
      width: 100,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () {
          if (m_mess == null) {
            normalDialog(context, 'กรุณาเกรอกข้อมูล');
          } else {
            insertReport();
          }
        },
        icon: Icon(
          Icons.send,
          color: Colors.white,
        ),
        label: Text(
          'ส่ง',
          style: GoogleFonts.sarabun(color: Colors.white),
        ),
      ),
    );
  }

  //ป้อนข้อมูล
  Widget messForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => m_mess = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        decoration: InputDecoration(prefixIcon: Icon(Icons.library_books_outlined), labelText: 'ข้อความ',labelStyle: GoogleFonts.sarabun(), border: OutlineInputBorder()),
      ));

FloatingActionButton roomMessage() {
  return FloatingActionButton(
    onPressed: () {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => ShowMessGroup(groupModel: groupModel,),
      );
      Navigator.push(context, route);
    },
    child: Icon(
      Icons.library_books_outlined,
      color: Colors.white,
    ),
    backgroundColor: Colors.deepOrange[400 ],
  );
}

//-----------------------------------------------------------------
}
