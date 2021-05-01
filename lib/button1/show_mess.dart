import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';

class ShowMess extends StatefulWidget {
  final RoomModel roomModel;

  ShowMess({Key key, this.roomModel}) : super(key: key);

  @override
  _ShowMessState createState() => _ShowMessState();
}

class _ShowMessState extends State<ShowMess> {
  RoomModel roomModel;
  List<RoomModel> roomModels = List();
  List<Widget> roomCards = List();
  String rId = '7';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readMess();
    roomModel = widget.roomModel;
    rId = roomModel.rId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${roomModel.rId}'),
      ),
      // เงื่อนไข ? จริง : เท็จ
      body: roomCards.length == 0
          ? MyStyle().showProgress()
          : SingleChildScrollView(
              child: Column(
              children: roomCards,
            )),
    );
  }

  //api เรียกดึงข้อูล room จากตาราง room_tb where id
  Future<Null> readMess() async {

    String r_id = rId;

    String url = '${MyDomain().domain}/Meeting/messageGet.php?isAdd=true&r_id=$r_id';

    print('data $r_id');

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        RoomModel model = RoomModel.fromJson(map);

        String rName = model.rName;
        if (rName.isNotEmpty) {
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
                    height: 20.0,
                    child: MyStyle().showTitle(roomModel.user),
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
                    MyStyle().showTitle(roomModel.mMess),
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
