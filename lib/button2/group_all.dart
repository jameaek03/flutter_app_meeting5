import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/group_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'group_detail.dart';

class GroupAll extends StatefulWidget {
  //รับค่าจาก ListRoom
  final GroupModel groupModel;

  GroupAll({Key key, this.groupModel}) : super(key: key);

  @override
  _GroupAllState createState() => _GroupAllState();
}

class _GroupAllState extends State<GroupAll> {
  GroupModel groupModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;
  List<GroupModel> groupModels = List();
  List<Widget> roomCards = List();

  String gId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupModel = widget.groupModel;
    gId = groupModel.gId;
    readRoom();
  }

  @override
  Widget build(BuildContext context) {
    //print('กลุ่ม${groupModel.gName}');
    return roomCards.length == 0
        ? MyStyle().showProgress()
        : Scaffold(
            appBar: AppBar(
              title: Text('หมวดหมู่ ${groupModel.gName}',style: GoogleFonts.sarabun(),),
              backgroundColor: Colors.deepOrange[400],
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
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
    String g_id = gId;

    String url = '${MyDomain().domain}/Meeting/getMroomList.php?isAdd=true&g_id=$g_id';
    await Dio().get(url).then((value) {
      //print('value = $value');
      //คลายรหัส utf8 เก็บใน result
      var result = json.decode(value.data);

      int index = 0;
      for (var map in result) {
        GroupModel model = GroupModel.fromJson(map);
        // print('NameShop = ${model.nameShop}');

        String gName = model.gName;
        if (gName.isNotEmpty) {
          setState(() {
            groupModels.add(model);
            roomCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  //card
  Widget createCard(GroupModel groupModel, int index) {
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => GroupDetail(groupModel: groupModels[index],),
        );
        Navigator.push(context, route);
      },
      child: Card(
        color: Colors.grey[200],
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
                      '${MyDomain().domain}${groupModel.rImg}',
                      fit: BoxFit.fill,
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
                    MyStyle().showTitle(groupModel.rName),
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
