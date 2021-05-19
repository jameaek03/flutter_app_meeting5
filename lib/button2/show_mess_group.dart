import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/group_model.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMessGroup extends StatefulWidget {
  final GroupModel groupModel;

  ShowMessGroup({Key key, this.groupModel}) : super(key: key);

  @override
  _ShowMessGroupState createState() => _ShowMessGroupState();
}

class _ShowMessGroupState extends State<ShowMessGroup> {
  GroupModel groupModel;
  List<GroupModel> groupModels = List();
  List<Widget> roomCards = List();
  String rId;

  String nameUser,PhoneUser,urlPictrueUser,addressUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupModel = widget.groupModel;
    rId = groupModel.rId;
    readMess();
    print(groupModel.rId.toString());
    //findUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${groupModel.rName}',style: GoogleFonts.sarabun()),
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

    String url = '${MyDomain().domain}/Meeting/messageGetMroom.php?isAdd=true&r_id=$r_id';

    print('data $r_id');

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print(result.toString());
      int index = 0;
      for (var map in result) {
        GroupModel model = GroupModel.fromJson(map);

        String rName = model.rName;
        if (rName.isNotEmpty) {
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
                  title: Text('ผู้ใช้งาน ${groupModel.name}',style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                  subtitle: Text('${groupModel.datetime}',style: GoogleFonts.sarabun()),
                  leading: CachedNetworkImage(
                    imageUrl: '${MyDomain().domain}${groupModel.urlPictrue}',
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
              title: Text('${groupModel.mMess}',style: GoogleFonts.sarabun(fontSize: 16,color: Colors.blueAccent.shade400),),
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
