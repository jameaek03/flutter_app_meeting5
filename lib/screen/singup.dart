import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/my_style.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String Name, User, Password, Address, Phone, UrlPictrue;
  String r_name;

  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp',style: GoogleFonts.mcLaren(),),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          groupImage(),
          SizedBox(height: 16.0,),
          showAppName(),
          SizedBox(height: 16.0,),
          nameForm(),
          SizedBox(height: 16.0,),
          userForm(),
          SizedBox(height: 16.0,),
          passwordForm(),
          SizedBox(height: 16.0,),
          AddressForm(),
          SizedBox(height: 16.0,),
          PhoneForm(),
          SizedBox(height: 16.0,),
          registerButton(),
        ],
      ),
    );
  }
  //อัพโหลดข้อมูลขึ้น server
  Future<Null> uploadInsertData() async {
    String urlUpload = '${MyDomain().domain}/Meeting/saveProfile.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'Profile$i.jpg';
    try{
      Map<String,dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path,filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload,data: formData).then((value) async{
        String UrlPictrue = '/Meeting/Profile/$nameFile';


        String urlInsertData = '${MyDomain().domain}/Meeting/register.php?isAdd=true&Name=$Name&User=$User&Password=$Password&Phone=$Phone&Address=$Address&UrlPictrue=$UrlPictrue';
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


  //API insert ข้อมูลขึ้น database
//  Future<Null> registerThread() async {
//    String url = '${MyDomain().domain}/Meeting/register.php?isAdd=true&Name=$Name&User=$User&Password=$Password&Address=$Address&Phone=$Phone';
//    try {
//      Response response = await Dio().get(url);
//      //
//      // if (response.toString() == 'true') {
//      //   //Navigator.pop(context);
//      // } else {
//      //   normalDialog(context, 'ไม่สำเร็จ');
//      // }
//    } catch (e) {}
//  }

  Widget registerButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().darColor,
          onPressed: () {
            if (Name == null || Name.isEmpty ||
                User == null || User.isEmpty ||
                Password == null || Password.isEmpty ||
                Address == null || Address.isEmpty ||
                Phone == null || Phone.isEmpty) {
              normalDialog(
                context,
                'มีช่องว่าง กรุณากรอกข้อมูลทุกช่อง',
              );
            } else {
              uploadInsertData();
            }
          },
          child: Text('Register',style: GoogleFonts.mcLaren(fontSize: 18,color: Colors.white,),
          ),
        ),
      );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => Name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darColor,
                ),
                labelStyle: GoogleFonts.mcLaren(color: MyStyle().darColor),
                labelText: 'name :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().darColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => User = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().darColor,
                ),
                labelStyle: GoogleFonts.mcLaren(color: MyStyle().darColor),
                labelText: 'user :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().darColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => Password = value.trim(),
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: MyStyle().darColor,
                ),
                labelStyle: GoogleFonts.mcLaren(color: MyStyle().darColor),
                labelText: 'Password :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().darColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget AddressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => Address = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home,
                  color: MyStyle().darColor,
                ),
                labelStyle: GoogleFonts.mcLaren(color: MyStyle().darColor),
                labelText: 'Address :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().darColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget PhoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => Phone = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: MyStyle().darColor,
                ),
                labelStyle: GoogleFonts.mcLaren(color: MyStyle().darColor),
                labelText: 'Phone :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().darColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().showTitle(
          'AppMeeting',
        ),
      ],
    );
  }


}
