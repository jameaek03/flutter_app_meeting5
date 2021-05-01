import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/button1/list_room.dart';
import 'package:flutter_app_meeting/button3/profile.dart';
import 'package:flutter_app_meeting/screen/top_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTabIndex = 0;
  Widget currentPage;

  //pages
  ListRoom listRoom;
  Top top;
  Profile profile;

  List<Widget> pages;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();

    listRoom = ListRoom();
    top = Top();
    profile = Profile();

    pages = [
      listRoom,
      top,
      profile,
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
              icon: FaIcon(FontAwesomeIcons.thLarge), title: Text("หมวดหมู่")),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell), title: Text("แจ้งเตือน")),
//          BottomNavigationBarItem(
//              icon: FaIcon(FontAwesomeIcons.edit), title: Text("รายงาน")),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.idBadge), title: Text("โปรไฟล์")),
        ],
      ),
    );
  }
}
