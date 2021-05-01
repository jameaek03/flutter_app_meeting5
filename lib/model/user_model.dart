class UserModel {
  String uId;
  String name;
  String user;
  String password;
  String address;
  String phone;
  String urlPictrue;

  UserModel(
      {this.uId,
      this.name,
      this.user,
      this.password,
      this.address,
      this.phone,
      this.urlPictrue});

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    address = json['Address'];
    phone = json['Phone'];
    urlPictrue = json['UrlPictrue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['u_id'] = this.uId;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['UrlPictrue'] = this.urlPictrue;
    return data;
  }
}
