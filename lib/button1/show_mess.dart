import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  String rId;


  String nameUser,PhoneUser,urlPictrueUser,addressUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomModel = widget.roomModel;
    rId = roomModel.rId;
    readMess();
    print(roomModel.rId.toString());
    //findUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${roomModel.rName}',style: GoogleFonts.sarabun()),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
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

//  Future<Null> findUser() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    setState(() {
//      nameUser = preferences.getString(
//        'Name',
//      );
//      PhoneUser = preferences.getString(
//        'Phone',
//      );
//      addressUser = preferences.getString(
//        'Address',
//      );
//      urlPictrueUser = preferences.getString(
//        'UrlPictrue',
//      );
//    });
//  }

  //api เรียกดึงข้อูล room จากตาราง room_tb where id
  Future<Null> readMess() async {

    String r_id = rId;

    String url = '${MyDomain().domain}/Meeting/messageGet.php?isAdd=true&r_id=$r_id';

    print('data $r_id');

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      //print(result.toString());

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
    return Card(
      elevation: 3,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: ListTile(
                  title: Text('ผู้ใช้งาน ${roomModel.name}',style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                  subtitle: Text('${roomModel.datetime}',style: GoogleFonts.sarabun()),
                  leading: CachedNetworkImage(
                      imageUrl: '${MyDomain().domain}${roomModel.urlPictrue}',
                    imageBuilder: (context, imageProvider){
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10)
                            ),
                          ),
                        );
                    },
                  ),
                  ),
                ),
              ),
            ),
          SingleChildScrollView(
            child: ListTile(
              title: Text('${roomModel.mMess}',style: GoogleFonts.sarabun(fontSize: 16,color: Colors.blueAccent.shade400),),
              //mainAxisAlignment: MainAxisAlignment.start,
              //children: <Widget>[
                //MyStyle().showTitle(roomModel.mMess),
              //],
            ),
          ),
        ],
      ),
    );
  }
}
