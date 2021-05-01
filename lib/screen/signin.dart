import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_meeting/model/user_model.dart';
import 'package:flutter_app_meeting/screen/home.dart';
import 'package:flutter_app_meeting/screen/singup.dart';
import 'package:flutter_app_meeting/utility/my_domain.dart';
import 'package:flutter_app_meeting/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String user, password, uId;
  bool showVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bcicon.png'),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Find Meeting',style: TextStyle(fontSize: 50,color: Colors.white,),),
                SizedBox(height: 16.0,),
                Text('Happy Moment',style: TextStyle(fontSize: 30,color: Colors.deepOrange,),),
                SizedBox(height: 80.0,),
                userForm(),
                SizedBox(height: 16.0,),
                passwordForm(),
                SizedBox(height: 16.0,),
                loginButton(),
                SizedBox(height: 16.0,),
                RegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  //เปิดหน้า
  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  //เช็คสถานะว่าไปหน้าไหน
  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String id = preferences.getString(
        'id',
      );
      if (id != null && id.isNotEmpty) {
        routeToService(
          Home(),
        );
      } else {
        //normalDialog(context, 'Error user type');
      }
    } catch (e) {}
  }


  Future<Null> chackAuthen() async {
    String url = '${MyDomain().domain}/Meeting/getUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);

      var result = json.decode(response.data);

      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        //print('$map');
        if (password == userModel.password) {
          routeTuService(Home(), userModel);
        } else {
          normalDialog(
            context,
            'password ผิดผลาดกรุณาลองใหม่',
          );
        }
      }
    } catch (e) {
      print('Have e Error ===>> ${e.toString()}');
    }
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    //ฝั่งข้อมูลผู็ใช้
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('User', userModel.user);
    preferences.setString('id', userModel.uId);
    preferences.setString('Name', userModel.name);
    preferences.setString('Phone', userModel.phone);
    preferences.setString('Address', userModel.address);
    preferences.setString('UrlPictrue', userModel.urlPictrue);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget RegisterButton() => Container(
        width: 300.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.white,
          onPressed: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => SignUp(),
            );
            Navigator.push(context, route);
          },
          child: Text('Register',style: TextStyle(fontSize: 18,color: Colors.deepOrange,),),
        ),
      );

  Widget loginButton() => Container(
        width: 300.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.deepOrange,
          onPressed: () {
            if (user == null || user.isEmpty || password == null || password.isEmpty) {
              normalDialog(
                context,
                'มีช่องว่าง กรุณาป้อนข้อมูลให้ครบ',
              );
            } else {
              chackAuthen();
            }
          },
          child: Text('Login',style: TextStyle(fontSize: 18,color: Colors.white,),),
        ),
      );

  Widget userForm() => Container(
        width: 300.0,
        child: TextFormField(
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.white,
            ),
            labelStyle: TextStyle(color: Colors.white,),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,),borderRadius: BorderRadius.circular(32.0)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,),borderRadius: BorderRadius.circular(32.0)),

          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 300.0,
        child: TextFormField(
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          onChanged: (value) => password = value.trim(),
          obscureText: showVisible,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            labelStyle: TextStyle(color: Colors.white,),
            labelText: 'Password :',
            suffixIcon: IconButton(
              onPressed: () {
                if (showVisible == true) {
                  setState(() {
                    showVisible = false;
                  });
                } else {
                  setState(() {
                    showVisible = true;
                  });
                }
              },
              icon: Icon(
                showVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,),borderRadius: BorderRadius.circular(32.0)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,),borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
      );
}
