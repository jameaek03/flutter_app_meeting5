import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';


class EditRoom extends StatefulWidget {

  final RoomModel roomModel;

  EditRoom({Key key, this.roomModel}) : super(key: key);


  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  RoomModel roomModel;
  File file;
  double Lat, Lng;
  String r_name, r_detail, r_img, Day, Time;

  //Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomModel = widget.roomModel;
    r_name = roomModel.rName;
    r_detail = roomModel.rDetail;
    r_img = roomModel.rImg;
    Day = roomModel.day;
    Time = roomModel.time;

    // findLatLng();
    // getLocation();
    // print('init Lat,Lng '+Lat.toString()+","+Lng.toString());
  }

  //------------------------map------------------
  // Set<Marker> myMarker() {
  //   print('My'+Lat.toString()+","+Lng.toString());
  //   return <Marker>[
  //     Marker(
  //       markerId: MarkerId(
  //         'ตำแหน่งของคุณ',
  //       ),
  //
  //       position: LatLng(
  //         Lat,
  //         Lng,
  //       ),
  //       infoWindow: InfoWindow(
  //         title: 'สถานที่จัดกิจกรรม',
  //
  //       ),
  //     ),
  //   ].toSet();
  // }
  //
  // Future<Null> findLatLng() async {
  //   LocationData locationData = await findLocationData();
  //   setState(() {
  //     Lat = locationData.latitude;
  //     Lng = locationData.longitude;
  //   });
  //   print('FindLatLng'+Lat.toString()+","+Lng.toString());
  //
  // }
  //
  // Future<LocationData> findLocationData() async {
  //   Location location = Location();
  //   try {
  //     Lat = 16.487357;
  //     Lng = 102.835101;
  //     return location.getLocation();
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // Future getLocation() async {
  //
  //   try {
  //     var currentLocation = await Location().getLocation();
  //     print(currentLocation.latitude.toString()+","+currentLocation.longitude.toString());
  //     final controller = await _controller.future;
  //     setState(() {
  //       controller
  //           .animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(currentLocation.latitude, currentLocation.longitude),
  //             zoom: 18.0,
  //           ),
  //         ),
  //       )
  //           .then((value) => myMarker());
  //     });
  //   } on Exception catch (e) {
  //     print('Could not get location: ${e.toString()}');
  //   }
  // }
  //
  // Widget roomMap() => Container(
  //   width: 300,
  //   height: 300,
  //   child: GoogleMap(
  //     initialCameraPosition: CameraPosition(
  //
  //       target: LatLng(Lat, Lng),
  //
  //
  //       zoom: 15,
  //     ),
  //     mapType: MapType.normal,
  //     onMapCreated: (GoogleMapController controller) {
  //       _controller.complete(controller);
  //     },
  //     myLocationEnabled: false,
  //     myLocationButtonEnabled: true,
  //     markers: myMarker(),
  //   ),
  // );
  //------------------------map------------------

  @override
  Widget build(BuildContext context) {
    //print(Lat.toString()+","+Lng.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('แก้ไขกิจกรรม ${roomModel.rName}',style: GoogleFonts.sarabun(),),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              groupImage(),
              nameRoom(),
              detailRoom(),
              DayRoom(),
              TimeRoom(),
              SizedBox(height: 20,),
              //Lat == null ? MyStyle().showProgress() : roomMap(),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (roomModel.rId != null) {
          conFirmEdit();
        } else {

        }
      },
      child: Icon(Icons.cloud_upload),
      backgroundColor: Colors.deepOrange[400],
    );
  }

  Future<Null> conFirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการเปลี่ยนแปลงเจริงๆนะ',style: GoogleFonts.sarabun(),),
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  uploadInsertData();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('เปลี่ยนแปลง',style: GoogleFonts.sarabun(),),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ไม่เปลี่ยนแปลง',style: GoogleFonts.sarabun(),),
              ),
            ],
          )
        ],
      ),
    );
  }


  //อัพโหลดข้อมูลขึ้น server
  Future<Null> uploadInsertData() async {
    String urlUpload = '${MyDomain().domain}/Meeting/saveRoom.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'meeting$i.jpg';
    try{
      Map<String,dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path,filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload,data: formData).then((value) async{
        String r_img = '/Meeting/Room/$nameFile';

        print('urlPathImage = ${MyDomain().domain}$r_img');

        String r_id = roomModel.rId;

        print('data1 $r_id');


        String urlInsertData = '${MyDomain().domain}/Meeting/editRoomWhereId.php?isAdd=true&r_id=$r_id&r_name=$r_name&r_img=$r_img&r_detail=$r_detail&Day=$Day&Time=$Time';
        await Dio().get(urlInsertData).then((value) => Navigator.pop(context));
      });

    }catch(e){
    }
  }


  Row groupImage() => Row(
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.add_a_photo),
        onPressed: () => chooseImage(ImageSource.camera),
      ),
      Container(
        padding: EdgeInsets.all(
          16.0,
        ),
        width: 275.0,
        height: 250.0,
        child: file == null
            ? Image.network(
          '${MyDomain().domain}${roomModel.rImg}',
          fit: BoxFit.cover,
        )
            : Image.file(file),
      ),
      IconButton(
        icon: Icon(Icons.add_photo_alternate),
        onPressed: () => chooseImage(ImageSource.gallery),
      ),
    ],
  );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameRoom() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 250.0,
        child: TextFormField(
          onChanged: (value) => r_name = value.trim(),
          initialValue: r_name, //เอาค่ามาใช้งาน
          decoration: InputDecoration(
            labelText: 'ชื่อ กิจกรรม',
            labelStyle: GoogleFonts.sarabun(),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget detailRoom() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 250.0,
        child: TextFormField(
          onChanged: (value) => r_detail = value.trim(),
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          initialValue: r_detail,

          decoration: InputDecoration(
            labelText: 'รายละเอียดกิจกรรม',
            labelStyle: GoogleFonts.sarabun(),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget DayRoom() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 250.0,
        child: TextFormField(
          onChanged: (value) => Day = value.trim(),
          initialValue: Day, //เอาค่ามาใช้งาน
          decoration: InputDecoration(
            labelText: 'วันที่',
            labelStyle: GoogleFonts.sarabun(),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget TimeRoom() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 250.0,
        child: TextFormField(
          onChanged: (value) => Time = value.trim(),
          initialValue: Time, //เอาค่ามาใช้งาน
          decoration: InputDecoration(
            labelText: 'เวลา',
            labelStyle: GoogleFonts.sarabun(),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );
}
