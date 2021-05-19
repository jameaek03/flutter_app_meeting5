import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button2/group_all.dart';
import 'package:flutter_app_meeting/model/group_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupRoom extends StatefulWidget {
  @override
  _GroupRoomState createState() => _GroupRoomState();
}

class _GroupRoomState extends State<GroupRoom> {
  String g_id;

  List<GroupModel> groupModels = List();
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
                title: Text(
                  'หมวดหมู่',style: GoogleFonts.sarabun(),
                ),
              centerTitle: true,
              backgroundColor: Colors.deepOrange[400],
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
  // Dio คือ แพ็คเก็ตอินเตอร์เน็ต คือโปรโตรคอล
  //api เรียกดึงข้อูล room จากตาราง room_tb where id
  Future<Null> readRoom() async {
    String url = '${MyDomain().domain}/Meeting/getMroom.php?isAdd=true';
    await Dio().get(url).then((value) {
      //print('value = $value');
      //คลายรหัส utf8 เก็บใน result
      var result = json.decode(value.data);

      int index = 0;
      for (var map in result) {
        GroupModel model = GroupModel.fromJson(map); //เอาค่า map ไปใส่ใน model
        // print('NameShop = ${model.nameShop}');

        String gName = model.gName;
        if (gName.isNotEmpty) { //isNotEmpty ถ้าไม่มีค่าว่าง
          setState(() {
            groupModels.add(model);
            roomCards.add(createCard(model, index)); //จะเอาการ์ดแแดเข้าไปใน รูมการNf จะเป็นการ์ดแบบ Index
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
          builder: (context) => GroupAll( groupModel: groupModels[index],),
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
                      '${MyDomain().domain}${groupModel.gImg}',
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
                    MyStyle().showTitle(groupModel.gName,),
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
