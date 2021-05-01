import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String valueChoose;
  List listItem = [
    "กรุงเทพมหานคร",
    "กระบี่",
    "กาญจนบุรี",
    "กาฬสินธุ์",
    "กำแพงเพชร",
    "ขอนแก่น",
    "จันทบุรี",
    "ฉะเชิงเทรา",
    "ชลบุรี",
    "ชัยนาท",
    "ชัยภูมิ",
    "ชุมพร",
    "เชียงราย",
    "เชียงใหม่",
    "ตรัง",
    "ตราด",
    "ตาก",
    "นครนายก",
    "นครปฐม",
    "นครพนม",
    "นครราชสีมา",
    "นครศรีธรรมราช",
    "นครสวรรค์",
    "นนทบุรี",
    "นราธิวาส",
    "น่าน",
    "บึงกาฬ",
    "บุรีรัมย์",
    "ปทุมธานี",
    "ประจวบคีรีขันธ์",
    "ปราจีนบุรี",
    "ปัตตานี",
    "พระนครศรีอยุธยา",
    "พังงา",
    "พัทลุง",
    "พิจิตร",
    "พิษณุโลก",
    "เพชรบุรี",
    "เพชรบูรณ์",
    "แพร่",
    "พะเยา",
    "ภูเก็ต",
    "มหาสารคาม",
    "มุกดาหาร",
    "แม่ฮ่องสอน",
    "ยะลา",
    "ยโสธร",
    "ร้อยเอ็ด",
    "ระนอง",
    "ระยอง",
    "ราชบุรี",
    "ลพบุรี",
    "ลำปาง",
    "ลำพูน",
    "เลย",
    "ศรีสะเกษ",
    "สกลนคร",
    "สงขลา",
    "สตูล",
    "สมุทรปราการ",
    "สมุทรสงคราม",
    "สมุทรสาคร",
    "สระแก้ว",
    "สระบุรี",
    "สิงห์บุรี",
    "สุโขทัย",
    "สุพรรณบุรี",
    "สุราษฎร์ธานี",
    "สุรินทร์",
    "หนองคาย",
    "หนองบัวลำภู",
    "อ่างทอง",
    "อุดรธานี",
    "อุทัยธานี",
    "อุตรดิตถ์",
    "อุบลราชธานี",
    "อำนาจเจริญ"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        title: Text(
          'หมวดหมู่',
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: _listSection(),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.grey[100],
                margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                child: Column(
                  children: <Widget>[
                    _headerCard(),
                    _bodyCard(),
                    _informationCard(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.grey[100],
                margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                child: Column(
                  children: <Widget>[
                    _headerCard2(),
                    _bodyCard2(),
                    _informationCard(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.grey[100],
                margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                child: Column(
                  children: <Widget>[
                    _headerCard3(),
                    _bodyCard3(),
                    _informationCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listSection() => Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(15)),
            child: DropdownButton(
              hint: Text("จังหวัด"),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              underline: SizedBox(),
              style: TextStyle(color: Colors.black, fontSize: 22),
              value: valueChoose,
              onChanged: (newValue) {
                setState(() {
                  valueChoose = newValue;
                });
              },
              items: listItem.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
        ),
      );
  Widget _headerCard() => ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: ClipOval(
            child: Image.network(
              "https://cdn.pixabay.com/photo/2018/11/29/21/51/social-media-3846597_1280.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "Jame Aek",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
        ),
        subtitle: Text(
          "Programmer",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
  Widget _bodyCard() => Image.network(
        "https://cdn.pixabay.com/photo/2017/06/23/10/48/code-2434271_1280.jpg",
        fit: BoxFit.cover,
      );
  Widget _informationCard() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _customFlatButton(icon: Icons.add_alert, label: "ติดตาม"),
          _customFlatButton(icon: Icons.map, label: "Maps"),
          SizedBox(
            width: 12,
          ),
        ],
      );
  Widget _customFlatButton({IconData icon, String label}) => FlatButton(
        onPressed: () {},
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 8,
            ),
            Text(label),
          ],
        ),
      );
  Widget _headerCard2() => ListTile(
    leading: Container(
      height: 50,
      width: 50,
      child: ClipOval(
        child: Image.network(
          "https://cdn.pixabay.com/photo/2018/11/29/21/51/social-media-3846597_1280.png",
          fit: BoxFit.cover,
        ),
      ),
    ),
    title: Text(
      "Jame Aek",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
    ),
    subtitle: Text(
      "ดูภาพยนตร์",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
  Widget _bodyCard2() => Image.network(
    "https://cdn.pixabay.com/photo/2017/07/13/23/11/cinema-2502213_1280.jpg",
    fit: BoxFit.cover,
  );
  Widget _headerCard3() => ListTile(
    leading: Container(
      height: 50,
      width: 50,
      child: ClipOval(
        child: Image.network(
          "https://cdn.pixabay.com/photo/2018/11/29/21/51/social-media-3846597_1280.png",
          fit: BoxFit.cover,
        ),
      ),
    ),
    title: Text(
      "Jame Aek",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
    ),
    subtitle: Text(
      "ดูคอนเสิร์ต",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
  Widget _bodyCard3() => Image.network(
    "https://cdn.pixabay.com/photo/2016/11/22/21/36/audience-1850665_1280.jpg",
    fit: BoxFit.cover,
  );



}
