class MessModel {
  String mId;
  String user;
  String mMess;
  String rId;
  String datetime;
  String rName;
  String rImg;
  String rDetail;
  String lat;
  String lng;

  MessModel(
      {this.mId,
        this.user,
        this.mMess,
        this.rId,
        this.datetime,
        this.rName,
        this.rImg,
        this.rDetail,
        this.lat,
        this.lng});

  MessModel.fromJson(Map<String, dynamic> json) {
    mId = json['m_id'];
    user = json['User'];
    mMess = json['m_mess'];
    rId = json['r_id'];
    datetime = json['datetime'];
    rName = json['r_name'];
    rImg = json['r_img'];
    rDetail = json['r_detail'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m_id'] = this.mId;
    data['User'] = this.user;
    data['m_mess'] = this.mMess;
    data['r_id'] = this.rId;
    data['datetime'] = this.datetime;
    data['r_name'] = this.rName;
    data['r_img'] = this.rImg;
    data['r_detail'] = this.rDetail;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}
