import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'file:///D:/flutter_app_meeting/lib/button3/create_room.dart';
import 'package:flutter_app_meeting/screen/edit_room.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListRoomUser extends StatefulWidget {
  @override
  _ListRoomUserState createState() => _ListRoomUserState();
}

class _ListRoomUserState extends State<ListRoomUser> {
  bool status = true; //havedata
  bool loadStatus = true; //process
  List<RoomModel> roomModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //เรียกค่า
    readRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().showProgress() : showContent(),
        createRoom(),
      ],
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

  //ดึงค่า
  Future<Null> readRoom() async {
    if (roomModels.length != 0) {
      roomModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String User = preferences.getString('User');
    print('User = $User');

    String url =
        '${MyDomain().domain}Meeting/getRoomUser.php?isAdd=true&User=$User';
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
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  //เอาข้อมูลมาแสดง
  Widget showListRoom() => ListView.builder(
        itemCount: roomModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${MyDomain().domain}${roomModels[index].rImg}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      roomModels[index].rName,

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              //passModel ไปที่หน้าแก้ไข
                              builder: (context) => EditRoom(
                                roomModel: roomModels[index],
                              ),
                            );
                          },
                        ),
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
