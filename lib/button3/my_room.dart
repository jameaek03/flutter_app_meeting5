import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';

import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_room.dart';
import 'edit_room.dart';

class MyRoom extends StatefulWidget {
  @override
  _MyRoomState createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  bool status = true; //havedata
  bool loadStatus = true; //process
  List<RoomModel> roomModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: createRoom(),
      appBar: AppBar(
        title: Text('กิจกรรมของฉัน',style: GoogleFonts.sarabun(),),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      body: loadStatus ? MyStyle().showProgress() : showContent(),
    );
  }

  //ดึงค่า
  Future<Null> readRoom() async {
    if (roomModels.length != 0) {
      roomModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String u_id = preferences.getString('id');
    print('User = $u_id');

    String url =
        '${MyDomain().domain}/Meeting/getRoomUser.php?isAdd=true&u_id=$u_id';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        //print('value ==>> $value');

        var result = json.decode(value.data);

        //print('result ==> $result');

        for (var map in result) {
          RoomModel roomModel = RoomModel.fromJson(map);
          setState(() {
            roomModels.add(roomModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  FloatingActionButton createRoom() {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => CreateRoom(),
        );
        Navigator.push(context, route);
      },
      backgroundColor: Colors.deepOrange[400],
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  //แสดงข้อมูลผู้ใช้
  Widget showContent() {
    return status
        ? showListRoom()
        : Center(
            child: Text('ยังไม่มีรายการ',style: GoogleFonts.sarabun(),),
          );
  }

  //เอาข้อมูลมาแสดง
  Widget showListRoom() => ListView.builder(
        itemCount: roomModels.length,
        itemBuilder: (context, index) => ClipRRect(
          //borderRadius: BorderRadius.circular(20.0),
          child: Card(
            margin: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.deepOrange[300],],
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: Image.network(
                      '${MyDomain().domain}${roomModels[index].rImg}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            roomModels[index].rName,
                            style:
                            GoogleFonts.sarabun(fontSize: 20, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.indigo[700],
                              ),
                              onPressed: () {
                                MaterialPageRoute route = MaterialPageRoute(
                                  //passModel ไปที่หน้าแก้ไข
                                  builder: (context) => EditRoom(
                                    roomModel: roomModels[index],
                                  ),
                                );
                                Navigator.push(context, route)
                                    .then((value) => EditRoom());
                              },
                            ),
                            Text('แก้ไข',style: GoogleFonts.sarabun(),),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => deleteRoom(roomModels[index]),
                            ),
                            Text('ลบกิจกรรม',style: GoogleFonts.sarabun(),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<Null> deleteRoom(RoomModel roomModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitle('คุณต้องการลบกิจกรรม ${roomModel.rName} ?'),titleTextStyle: GoogleFonts.sarabun(),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  String url =
                      '${MyDomain().domain}/Meeting/deleteRoomWhereId.php?isAdd=true&r_id=${roomModel.rId}';
                  await Dio().get(url).then((value) => readRoom());
                  Navigator.pop(context);
                },
                child: Text('ยืนยัน',style: GoogleFonts.sarabun(),),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก',style: GoogleFonts.sarabun(),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
