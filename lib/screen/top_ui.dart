
import 'package:flutter/material.dart';
import 'package:flutter_app_meeting/model/card_item.dart';


class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {


  List<CardItem> items = <CardItem>[
    CardItem(
      title: 'Programmer',
      color: Colors.orange,
      urlImage:
      'https://cdn.pixabay.com/photo/2017/06/23/10/48/code-2434271_1280.jpg',
    ),
    CardItem(
      title: 'ดูภาพยนตร์',
      color: Colors.redAccent,
      urlImage:
      'https://cdn.pixabay.com/photo/2017/07/13/23/11/cinema-2502213_1280.jpg',
    ),
    CardItem(
      title: 'สวนสนุก',
      color: Colors.deepPurple,
      urlImage:
      'https://cdn.pixabay.com/photo/2016/07/01/23/16/carnival-1492099_1280.jpg',
    ),
    CardItem(
      title: 'ปั่นจักรยาน',
      color: Colors.green,
      urlImage:
      'https://cdn.pixabay.com/photo/2020/09/04/12/50/tour-de-france-5543999_1280.jpg',
    ),
    CardItem(
      title: 'ขี้ม้า',
      color: Colors.red,
      urlImage:
      'https://cdn.pixabay.com/photo/2012/12/19/18/14/horse-71080_1280.jpg',
    ),
    CardItem(
      title: 'อเมริกันฟุตบอล',
      color: Colors.white,
      urlImage:
      'https://cdn.pixabay.com/photo/2021/01/03/11/00/american-football-5884158_1280.jpg',
    ),
    CardItem(
      title: 'ดูคอนเสิร์ต',
      color: Colors.yellow,
      urlImage:
      'https://cdn.pixabay.com/photo/2016/11/22/21/36/audience-1850665_1280.jpg',
    ),
    CardItem(
      title: 'ปาร์ตี้',
      color: Colors.purple,
      urlImage:
      'https://cdn.pixabay.com/photo/2017/07/21/23/57/concert-2527495_1280.jpg',
    ),
    CardItem(
      title: 'ว่ายน้ำ',
      color: Colors.blue,
      urlImage:
      'https://cdn.pixabay.com/photo/2013/02/05/19/16/swimming-78112_1280.jpg',
    ),
    CardItem(
      title: 'เทนนิส',
      color: Colors.brown,
      urlImage:
      'https://cdn.pixabay.com/photo/2016/09/15/15/27/tennis-court-1671852_1280.jpg',
    ),
  ];


  @override
  Widget build(BuildContext context) {

    final double padding = 8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[400],
        centerTitle: true,
        title: Text(
          'กิจกรรมสุดฮอต',
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
      ),
      backgroundColor: Colors.yellow[100],
      body: GestureDetector(
        onTap: (){

        },
        child: GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
            childAspectRatio: 3 / 4,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return buildCard(item: item);
          },
        ),
      ),
    );
  }

  Widget buildCard({@required CardItem item}) => GestureDetector(
    onTapDown: (_) => setTapped(item, isTapped: true),
    onTapUp: (_) => setTapped(item, isTapped: false),
    onTapCancel: () => setTapped(item, isTapped: false),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: item.color,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: item.isTapped ? 1 : 0.5,
              child: Image.network(item.urlImage, fit: BoxFit.cover),
            ),
          ),
          if (!item.isTapped)
            Center(
              child: Text(
                item.title,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
        ],
      ),
    ),
  );

  void setTapped(CardItem item, {@required bool isTapped}) {
    setState(() {
      this.items = items
          .map((otherItem) =>
      item == otherItem ? item.copy(isTapped: isTapped) : otherItem)
          .toList();
    });
  }
}
