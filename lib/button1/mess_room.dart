import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/show_mess.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessRoom extends StatefulWidget {
  final RoomModel roomModel;

  MessRoom({Key key, this.roomModel}) : super(key: key);

  @override
  _MessRoomState createState() => _MessRoomState();
}

class _MessRoomState extends State<MessRoom> {
  RoomModel roomModel;
  String r_name, m_mess, r_id;

  List<RoomModel> roomModels = List();

  List<Widget> roomCards = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomModel = widget.roomModel;
    r_name = roomModel.rName;
    r_id = roomModel.rId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: roomMessage(),
      appBar: AppBar(
        title: Text('${roomModel.rName}'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              messForm(),
              SizedBox(
                width: 20.0,
              ),
              send(),
            ],
          ),
        ],
      ),
    );
  }



  //-----------------------------------------------------------------
  //บันทึกข้อมูลขึ้น database
  Future<Null> insertReport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String User = preferences.getString('User');

    String url = '${MyDomain().domain}/Meeting/messageInsert.php?isAdd=true&User=$User&m_mess=$m_mess&r_id=$r_id';

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
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'ส่ง',
          style: TextStyle(color: Colors.white),
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
        decoration: InputDecoration(prefixIcon: Icon(Icons.library_books_outlined), labelText: 'ข้อความ', border: OutlineInputBorder()),
      ));

FloatingActionButton roomMessage() {
  return FloatingActionButton(
    onPressed: () {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => ShowMess(roomModel: roomModel,),
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
