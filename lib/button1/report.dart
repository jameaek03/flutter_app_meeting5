import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/room_model.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Report extends StatefulWidget {
  final RoomModel roomModel;

  //  รัยค่า
  Report({Key key, this.roomModel}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  //File file;
  String Detail, r_name;

  RoomModel roomModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomModel = widget.roomModel;
    r_name = roomModel.rName;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายงาน ${roomModel.rName}'),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              detailForm(),
              SizedBox(
                height: 10,
              ),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: 500,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () {
          if (Detail == null) {
            normalDialog(context, 'กรุณาเกรอกข้อมูล');
          } else {
            insertReport();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> insertReport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String User = preferences.getString('User');

    String url =
        '${MyDomain().domain}/Meeting/reportRoom.php?isAdd=true&User=$User&r_name=$r_name&Detail=$Detail';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'สำเร็จ');
      }
    });
  }

  //ป้อนข้อมูล
  Widget detailForm() => Container(
      width: 500.0,
      child: TextField(
        onChanged: (value) => Detail = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: 'รายละเอียดปัญหา',
            border: OutlineInputBorder()),
      ));
}
