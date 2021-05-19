import 'dart:async';

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/list_room.dart';
import 'package:flutter_app_meeting/button1/mess_room.dart';
import 'package:flutter_app_meeting/button1/report.dart';
import 'package:flutter_app_meeting/button2/list_group.dart';
import 'package:flutter_app_meeting/button3/profile.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoomDetail extends StatefulWidget {
  //รับค่าจาก ListRoom
  final RoomModel roomModel;

  RoomDetail({Key key, this.roomModel}) : super(key: key);

  final index = 0;

  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  Completer<GoogleMapController> _controller = Completer();

  RoomModel roomModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;

  double lat, lng;

  //-----------------------------------





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomModel = widget.roomModel;
    findLatLng();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: roomMessage(),
      appBar: AppBar(
        title: Text(
          '${roomModel.rName}',
          style: GoogleFonts.sarabun(),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[400],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment_late_outlined),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => Report(
                  roomModel: roomModel,
                ),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  child: Image.network(
                    '${MyDomain().domain}${roomModel.rImg}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text(
                  "สถานที่จัดกิจกรรม",
                  style: GoogleFonts.sarabun(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              roomMap(),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.grey.shade600,
                endIndent: 20,
                indent: 20,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "รายละเอียดกิจกรรม",
                                      style: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${roomModel.rDetail}',
                                      style: GoogleFonts.sarabun(),
                                    ),
                                    leading: Icon(Icons.article_rounded,
                                        color: Colors.black),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text(
                                      "วันที่",
                                      style: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${roomModel.day}',
                                      style: GoogleFonts.sarabun(),
                                    ),
                                    leading:
                                        Icon(Icons.today, color: Colors.black),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text(
                                      "เวลา",
                                      style: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${roomModel.time}',
                                      style: GoogleFonts.sarabun(),
                                    ),
                                    leading: Icon(
                                      Icons.timer,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


//--------แผนที่----------//

  Future<Null> findLatLng() async {
    setState(() {
      lat = double.parse(roomModel.lat); //คอนเวิสค่า = แปรงค่า
      lng = double.parse(roomModel.lng);
    });
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId(
          'ตำแหน่งงาน',
        ),
        position: LatLng(
          lat,
          lng,
        ),
        infoWindow: InfoWindow(
          title: '${roomModel.rName}',
        ),
      ),
    ].toSet();
  }

  Widget roomMap() => Container(
        width: 300,
        height: 300,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15,
          ),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: false,
          myLocationButtonEnabled: true,
          markers: myMarker(),
        ),
      );
  //--------แผนที่----------//

  FloatingActionButton roomMessage() {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => MessRoom(
            roomModel: roomModel,
          ),
        );
        Navigator.push(context, route);
      },
      child: Icon(
        Icons.library_books_outlined,
        color: Colors.white,
      ),
      backgroundColor: Colors.deepOrange[400],
    );
  }
}
