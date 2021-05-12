import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button3/my_room.dart';
import 'package:flutter_app_meeting/model/room_model.dart';

import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/signout_process.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RoomModel roomModel;

  String nameUser;
  String PhoneUser;
  String urlPictrueUser;
  String addressUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString(
        'Name',
      );
      PhoneUser = preferences.getString(
        'Phone',
      );
      addressUser = preferences.getString(
        'Address',
      );
      urlPictrueUser = preferences.getString(
        'UrlPictrue',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: createRoom(),
      appBar: AppBar(
        title: Text('ข้อมูลส่วนตัว',style: GoogleFonts.sarabun(),),
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () => signOutProcess(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 320.0,
                  height: 180.0,
                  child: Image.network(
                    '${MyDomain().domain}${urlPictrueUser}',
                    fit: BoxFit.cover,
                  ),
                ),
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
                                    title: Text("User information",style: GoogleFonts.mcLaren(fontSize: 20,fontWeight: FontWeight.bold,),),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text("Name",style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold),),
                                    subtitle: Text("$nameUser",style: GoogleFonts.sarabun(),),
                                    leading: Icon(Icons.person,color: Colors.black,),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text("Phone",style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold),),
                                    subtitle: Text("$PhoneUser",style: GoogleFonts.sarabun(),),
                                    leading: Icon(Icons.phone,color: Colors.black),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  ListTile(
                                    title: Text("อาศัยอยู่ที่",style: GoogleFonts.sarabun(fontWeight: FontWeight.bold),),
                                    subtitle: Text("$addressUser",style: GoogleFonts.sarabun(),),
                                    leading: Icon(Icons.home,color: Colors.black),
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

              // Row(
              //   children: [
              //     myRoom(),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }


  FloatingActionButton createRoom() {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => MyRoom(),
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
