import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowRoom extends StatefulWidget {
  @override
  _FollowRoomState createState() => _FollowRoomState();
}

class _FollowRoomState extends State<FollowRoom> {

  bool status = true; //havedata
  bool loadStatus = true; //process

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('รายการที่ติดตาม',style: GoogleFonts.sarabun(),),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      //body: loadStatus ? MyStyle().showProgress() : showContent(),
    );


  }

  //แสดงข้อมูลผู้ใช้
//  Widget showContent() {
//    return status
//        ? showFollowRoom()
//        : Center(
//      child: Text('ยังไม่มีรายการ'),
//    );
//  }

//  Widget showFollowRoom() => ListView.builder(
//    itemCount: roomModels.length,
//    itemBuilder: (context, index) => ClipRRect(
//      //borderRadius: BorderRadius.circular(20.0),
//      child: Card(
//        margin: EdgeInsets.only(top: 12, left: 12,right: 12,bottom: 10),
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//        elevation: 8,
//        child: Container(
//          height: 200,
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(16),
//            gradient: LinearGradient(
//              colors: [Colors.yellow[200],Colors.green[200]],
//            ),
//          ),
//
//          child: Row(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.symmetric(horizontal: 20),
//                width: MediaQuery.of(context).size.width * 0.5,
//                height: MediaQuery.of(context).size.width * 0.4,
//
//                child: Image.network(
//                  '${MyDomain().domain}${roomModels[index].rImg}',
//                  fit: BoxFit.cover,
//                ),
//              ),
//              Container(
//                padding: EdgeInsets.all(20.0),
//                width: MediaQuery.of(context).size.width * 0.4,
//                height: MediaQuery.of(context).size.width * 0.5,
//                child: SingleChildScrollView(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Text(
//                        roomModels[index].rName,
//                        style: TextStyle(fontSize: 20,color: Colors.black),
//                      ),
//                      SizedBox(height: 20,),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          RaisedButton.icon(
//                            icon: Icon(
//                              Icons.edit,
//                              color: Colors.indigo[700],
//                            ),
//                            onPressed: () {
//                              MaterialPageRoute route = MaterialPageRoute(
//                                //passModel ไปที่หน้าแก้ไข
//                                builder: (context) => EditRoom(
//                                  roomModel: roomModels[index],
//                                ),
//                              );
//                              Navigator.push(context, route)
//                                  .then((value) => EditRoom());
//                            },
//                          ),
//
//
//                        ],
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    ),
//  );
}

