import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button2/mess_room_group.dart';
import 'package:flutter_app_meeting/button2/report_group.dart';
import 'package:flutter_app_meeting/model/group_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GroupDetail extends StatefulWidget {
  final GroupModel groupModel;

  GroupDetail({Key key, this.groupModel}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  Completer<GoogleMapController> _controller = Completer();

  GroupModel groupModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;


  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupModel = widget.groupModel;
    findLatLng();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: roomMessage(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('${groupModel.rName}',style: GoogleFonts.sarabun(),),
        backgroundColor: Colors.deepOrange[400],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment_late_outlined),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => ReportGroup(
                  groupModel: groupModel,
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
                    '${MyDomain().domain}${groupModel.rImg}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text("สถานที่จัดกิจกรรม",style: GoogleFonts.sarabun(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
              roomMap(),
              SizedBox(height: 20,),
              Divider(
                color: Colors.grey.shade600,
                endIndent: 20,
                indent: 20,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0,30.0,16.0,16.0),
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
                                    title: Text("รายละเอียดกิจกรรม",style: GoogleFonts.sarabun(fontWeight: FontWeight.bold),),
                                    subtitle: Text('${groupModel.rDetail}',style: GoogleFonts.sarabun(),),
                                    leading: Icon(Icons.article_rounded,color: Colors.black),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text("วันที่",style: GoogleFonts.sarabun(fontWeight: FontWeight.bold),),
                                    subtitle: Text('${groupModel.day}',style: GoogleFonts.sarabun()),
                                    leading: Icon(Icons.today,color: Colors.black),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text("เวลา",style: GoogleFonts.sarabun(fontWeight: FontWeight.bold),),
                                    subtitle: Text('${groupModel.time}',style: GoogleFonts.sarabun()),
                                    leading: Icon(Icons.timer,color: Colors.black,),
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
              SizedBox(height: 12,),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      color: Colors.green,
      width: 200,
      child: RaisedButton.icon(
        icon: Icon(
          Icons.where_to_vote,
          color: Colors.white,
        ),
        label: Text(
          'เข้าร่วม',
          style: GoogleFonts.sarabun(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> findLatLng() async {
    setState(() {
      lat = double.parse(groupModel.lat);
      lng = double.parse(groupModel.lng);
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
          title: '${groupModel.rName}',
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

  FloatingActionButton roomMessage() {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => MessRoomGroup(groupModel: groupModel,),
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
