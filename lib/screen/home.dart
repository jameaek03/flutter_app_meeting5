import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/list_room.dart';
import 'package:flutter_app_meeting/button2/list_group.dart';
import 'package:flutter_app_meeting/button3/profile.dart';
import 'package:flutter_app_meeting/button4/follow_room.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTabIndex = 0;
  Widget currentPage;

  //pages
  ListRoom listRoom;
  GroupRoom groupRoom;
  Profile profile;
  FollowRoom followRoom;

  List<Widget> pages;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();

    listRoom = ListRoom();
    groupRoom = GroupRoom();
    profile = Profile();
    followRoom = FollowRoom();

    pages = [
      listRoom,
      groupRoom,
      profile,
      followRoom,
    ];
    currentPage = listRoom;

  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange[400],
        fixedColor: Colors.white,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), title: Text("หน้าแรก",style: GoogleFonts.sarabun(),)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.thLarge), title: Text("หมวดหมู่",style: GoogleFonts.sarabun(),)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.idBadge), title: Text("โปรไฟล์",style: GoogleFonts.sarabun(),)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart), title: Text("ติดตาม",style: GoogleFonts.sarabun(),)),
        ],
      ),
    );
  }
}
