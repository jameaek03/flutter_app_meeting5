//
//
// class RoomModel {
//   String mId;
//   String user;
//   String mMess;
//   String rId;
//   String datetime;
//   String rName;
//   String rImg;
//   String rDetail;
//   String day;
//   String time;
//   String lat;
//   String lng;
//
//   RoomModel(
//       {this.mId,
//         this.user,
//         this.mMess,
//         this.rId,
//         this.datetime,
//         this.rName,
//         this.rImg,
//         this.rDetail,
//         this.day,
//         this.time,
//         this.lat,
//         this.lng});
//
//   RoomModel.fromJson(Map<String, dynamic> json) {
//     mId = json['m_id'];
//     user = json['User'];
//     mMess = json['m_mess'];
//     rId = json['r_id'];
//     datetime = json['datetime'];
//     rName = json['r_name'];
//     rImg = json['r_img'];
//     rDetail = json['r_detail'];
//     day = json['Day'];
//     time = json['Time'];
//     lat = json['Lat'];
//     lng = json['Lng'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['m_id'] = this.mId;
//     data['User'] = this.user;
//     data['m_mess'] = this.mMess;
//     data['r_id'] = this.rId;
//     data['datetime'] = this.datetime;
//     data['r_name'] = this.rName;
//     data['r_img'] = this.rImg;
//     data['r_detail'] = this.rDetail;
//     data['Day'] = this.day;
//     data['Time'] = this.time;
//     data['Lat'] = this.lat;
//     data['Lng'] = this.lng;
//     return data;
//   }
// }

class RoomModel {
  String rId;
  String uId;
  String rName;
  String rImg;
  String rDetail;
  String day;
  String time;
  String lat;
  String lng;
  String mId;
  String mMess;
  String datetime;
  String name;
  String user;
  String password;
  String address;
  String phone;
  String urlPictrue;

  RoomModel(
      {this.rId,
        this.uId,
        this.rName,
        this.rImg,
        this.rDetail,
        this.day,
        this.time,
        this.lat,
        this.lng,
        this.mId,
        this.mMess,
        this.datetime,
        this.name,
        this.user,
        this.password,
        this.address,
        this.phone,
        this.urlPictrue});

  RoomModel.fromJson(Map<String, dynamic> json) {
    rId = json['r_id'];
    uId = json['u_id'];
    rName = json['r_name'];
    rImg = json['r_img'];
    rDetail = json['r_detail'];
    day = json['Day'];
    time = json['Time'];
    lat = json['Lat'];
    lng = json['Lng'];
    mId = json['m_id'];
    mMess = json['m_mess'];
    datetime = json['datetime'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    address = json['Address'];
    phone = json['Phone'];
    urlPictrue = json['UrlPictrue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r_id'] = this.rId;
    data['u_id'] = this.uId;
    data['r_name'] = this.rName;
    data['r_img'] = this.rImg;
    data['r_detail'] = this.rDetail;
    data['Day'] = this.day;
    data['Time'] = this.time;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['m_id'] = this.mId;
    data['m_mess'] = this.mMess;
    data['datetime'] = this.datetime;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['UrlPictrue'] = this.urlPictrue;
    return data;
  }
}
