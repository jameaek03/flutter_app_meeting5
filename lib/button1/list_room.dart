import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/room_detail.dart';
import 'package:flutter_app_meeting/model/room_model.dart';

import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';

class ListRoom extends StatefulWidget {
  @override
  _ListRoomState createState() => _ListRoomState();
}

class _ListRoomState extends State<ListRoom> {
  String r_id;

  List<RoomModel> roomModels = List();
  List<Widget> roomCards = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readRoom();
  }

  @override
  Widget build(BuildContext context) {
    return roomCards.length == 0
        ? MyStyle().showProgress()
        : Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  'Find Meeting',
                ),
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: GridView.extent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: roomCards,
            ),
          );
  }

  //api เรียกดึงข้อูล room จากตาราง room_tb where id
  Future<Null> readRoom() async {
    String url = '${MyDomain().domain}/Meeting/getRoomWhereIdUser.php?isAdd=true&r_id=$r_id';
    await Dio().get(url).then((value) {
      //print('value = $value');
      //คลายรหัส utf8 เก็บใน result
      var result = json.decode(value.data);

      int index = 0;
      for (var map in result) {
        RoomModel model = RoomModel.fromJson(map);
        // print('NameShop = ${model.nameShop}');

        String rName = model.rName;
        if (rName.isNotEmpty) {
          print('rName = ${model.rName}');
          setState(() {
            roomModels.add(model);
            roomCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  //card
  Widget createCard(RoomModel roomModel, int index) {
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => RoomDetail(
            roomModel: roomModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150.0,
                    child: Image.network(
                      '${MyDomain().domain}${roomModel.rImg}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  children: [
                    MyStyle().showTitle(roomModel.rName),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
