import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';


class EditRoom extends StatefulWidget {

  final RoomModel roomModel;

  EditRoom({Key key, this.roomModel}) : super(key: key);


  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  RoomModel roomModel;
  File file;
  String r_name, r_detail, r_img;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomModel = widget.roomModel;
    r_name = roomModel.rName;
    r_detail = roomModel.rDetail;
    r_img = roomModel.rImg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('แก้ไขกิจกกรม ${roomModel.rName}'),
        backgroundColor: Colors.deepOrange[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            groupImage(),
            nameRoom(),
            detailRoom(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (r_name.isEmpty || r_detail.isEmpty) {
          normalDialog(context, 'กรุณากรอกช่อมูลให้ครบ ');
        } else {
          conFirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> conFirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการเปลี่ยนแปลงเจริงๆนะ'),
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
                label: Text('เปลี่ยนแปลง'),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ยังไม่เปลี่ยนแปลง'),
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


        String urlInsertData = '${MyDomain().domain}/Meeting/editRoomWhereId.php?isAdd=true&r_id=$r_id&r_name=$r_name&r_detail=$r_detail&r_img=$r_img';
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
        width: 250.0,
        height: 250.0,
        child: file == null
            ? Image.network(
          '${MyDomain().domain}${roomModel.rImg}',
          fit: BoxFit.cover,
        )
            : Image.file(file),
      ),
      IconButton(
        icon: Icon(Icons.add_photo_alternate_outlined),
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
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          initialValue: r_detail,

          decoration: InputDecoration(
            labelText: 'รายละเอียดกิจกรรม',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );
}
