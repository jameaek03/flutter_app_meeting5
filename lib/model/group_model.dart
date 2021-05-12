//class GroupModel {
//  String gId;
//  String gName;
//  String gImg;
//  String rId;
//  String uId;
//  String rName;
//  String rImg;
//  String rDetail;
//  String day;
//  String time;
//  String lat;
//  String lng;
//
//  GroupModel(
//      {this.gId,
//        this.gName,
//        this.gImg,
//        this.rId,
//        this.uId,
//        this.rName,
//        this.rImg,
//        this.rDetail,
//        this.day,
//        this.time,
//        this.lat,
//        this.lng});
//
//  GroupModel.fromJson(Map<String, dynamic> json) {
//    gId = json['g_id'];
//    gName = json['g_name'];
//    gImg = json['g_img'];
//    rId = json['r_id'];
//    uId = json['u_id'];
//    rName = json['r_name'];
//    rImg = json['r_img'];
//    rDetail = json['r_detail'];
//    day = json['Day'];
//    time = json['Time'];
//    lat = json['Lat'];
//    lng = json['Lng'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['g_id'] = this.gId;
//    data['g_name'] = this.gName;
//    data['g_img'] = this.gImg;
//    data['r_id'] = this.rId;
//    data['u_id'] = this.uId;
//    data['r_name'] = this.rName;
//    data['r_img'] = this.rImg;
//    data['r_detail'] = this.rDetail;
//    data['Day'] = this.day;
//    data['Time'] = this.time;
//    data['Lat'] = this.lat;
//    data['Lng'] = this.lng;
//    return data;
//  }
//}

class GroupModel {
  String gId;
  String gName;
  String gImg;
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

  GroupModel(
      {this.gId,
        this.gName,
        this.gImg,
        this.rId,
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

  GroupModel.fromJson(Map<String, dynamic> json) {
    gId = json['g_id'];
    gName = json['g_name'];
    gImg = json['g_img'];
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
    data['g_id'] = this.gId;
    data['g_name'] = this.gName;
    data['g_img'] = this.gImg;
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
