import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'file:///D:/flutter_app_meeting/lib/button3/create_room.dart';

import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/edit_room.dart';

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
      floatingActionButton: createRoom(),
      appBar: AppBar(
        title: Text('กิจกรรมของฉัน'),
        backgroundColor: Colors.deepOrange[400],
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
    String User = preferences.getString('User');
    print('User = $User');

    String url =
        '${MyDomain().domain}/Meeting/getRoomUser.php?isAdd=true&User=$User';
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
            child: Text('ยังไม่มีรายการ'),
          );
  }

  //เอาข้อมูลมาแสดง
  Widget showListRoom() => ListView.builder(
        itemCount: roomModels.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.only(bottom: 12, right: 20, left: 20, top: 20),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 6, right: 10, left: 10),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.4,
                child: Image.network(
                  '${MyDomain().domain}${roomModels[index].rImg}',
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        roomModels[index].rName,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(width: 20,),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteRoom(roomModels[index]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<Null> deleteRoom(RoomModel roomModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitle('คุณต้องการลบกิจกรรม ${roomModel.rName} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =

                      '${MyDomain().domain}/Meeting/deleteRoomWhereId.php?isAdd=true&r_id=${roomModel.rId}';
                  await Dio().get(url).then((value) => readRoom());
                },
                child: Text('ยืนยัน'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
