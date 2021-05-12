import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRoom extends StatefulWidget {



  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {

  Completer<GoogleMapController> _controller = Completer();
  String r_name, r_detail, Day, Time;
  double Lat, Lng;
  File file;


  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
    findLatLng();
  }


  //------------------------map------------------
  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId(
          'ตำแหน่งของคุณ',
        ),
        position: LatLng(
          Lat,
          Lng,
        ),
        infoWindow: InfoWindow(
          title: 'สถานที่จัดกิจกรรม',

        ),
      ),
    ].toSet();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      Lat = locationData.latitude;
      Lng = locationData.longitude;
    });

  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future getLocation() async {
    try {
      var currentLocation = await Location().getLocation();
      final controller = await _controller.future;
      setState(() {
        controller
            .animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 18.0,
                ),
              ),
            )
            .then((value) => myMarker());
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
  }

  Widget roomMap() => Container(
        width: 300,
        height: 300,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(Lat, Lng),
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
  //------------------------map------------------



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('สร้างห้องกิจกรรม',style: GoogleFonts.sarabun(),),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              groupImage(),
              SizedBox(
                height: 20.0,
              ),
              nameForm(),
              SizedBox(
                height: 14.0,
              ),
              detailForm(),
              SizedBox(
                height: 20.0,
              ),
              dayForm(),
              SizedBox(
                height: 20.0,
              ),
              timeForm(),
              SizedBox(
                height: 20.0,
              ),
              Lat == null ? MyStyle().showProgress() : roomMap(),
              SizedBox(
                height: 20.0,
              ),
              saveButton(),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'กรุณาเลือกรูป');
          } else if (r_name == null || r_name.isEmpty || r_detail == null || r_detail.isEmpty) {
            normalDialog(context, 'กรุณากรอกช้อมูลทุกช่อง');
          } else {
            uploadInsertData();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'บันทึกข้อมูล',
          style: GoogleFonts.sarabun(color: Colors.white),
        ),
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
        // เจนพาทไฟล์รูป
        String r_img = '/Meeting/Room/$nameFile';

        print('urlPathImage = ${MyDomain().domain}$r_img');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String u_id = preferences.getString('id');

        String urlInsertData = '${MyDomain().domain}/Meeting/addRoom.php?isAdd=true&u_id=$u_id&r_name=$r_name&r_img=$r_img&r_detail=$r_detail&Day=$Day&Time=$Time&Lat=$Lat&Lng=$Lng';
        await Dio().get(urlInsertData).then((value) => Navigator.pop(context));


      });


    }catch(e){

    }
  }

  //กำหนดขนาดไฟล์รูปภาพ
  Future<Null> choseImage(ImageSource source) async {
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

  //แสดงรูปภาพ
  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => choseImage(ImageSource.camera),
        ),
        Container(
          width: 160.0,
          height: 160.0,
          child: file == null ? Image.asset('assets/images/logoup.png') : Image.file(file),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => choseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  //ป้อนชื่อกิจกรรม
  Widget nameForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => r_name = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        decoration: InputDecoration(prefixIcon: Icon(Icons.library_books_outlined), labelText: 'ชื่อกิจกรรม :',labelStyle: GoogleFonts.sarabun(), border: OutlineInputBorder()),
      ));

  //ป้อนชื่อกิจกรรม
  Widget detailForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => r_detail = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        decoration: InputDecoration(prefixIcon: Icon(Icons.web_sharp), labelText: 'รายละเอียดกิจกรรม :',labelStyle: GoogleFonts.sarabun(), border: OutlineInputBorder()),
      ));

  Widget dayForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => Day = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        decoration: InputDecoration(prefixIcon: Icon(Icons.today), labelText: 'วันที่ :',labelStyle: GoogleFonts.sarabun(), border: OutlineInputBorder()),
      ));

  Widget timeForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => Time = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        decoration: InputDecoration(prefixIcon: Icon(Icons.timer), labelText: 'เวลา :',labelStyle: GoogleFonts.sarabun(), border: OutlineInputBorder()),
      ));

}
