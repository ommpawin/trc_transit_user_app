//Main Package
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

//Dependencies Package
import 'package:dio/dio.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//Import Screen
import 'package:trc_transit/screens/login_screen.dart';
import 'package:trc_transit/screens/home_screen.dart';

//Import Setting
import 'package:trc_transit/_setting.dart';

class LoadSC extends StatefulWidget {
  @override
  _LoadSCState createState() => _LoadSCState();
}

class _LoadSCState extends State<LoadSC> {
  var session = FlutterSession();

  @override
  void initState() {
    checkSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD304),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/images/TRC_Transit.png",
              width: 200.0,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: SpinKitDoubleBounce(
                color: Color(0xFFFFFFFF),
                size: 60.0,
              ),
            ),
          )
        ])),
      ),
    );
  }

  void checkSessionData() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull = "$domain/check_access_status?condition=externalAccessStatus";
    var dataPack = Map<String, dynamic>();

    dynamic checkIdUser = await session.get("idUser");

    if (checkIdUser == "" || checkIdUser == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginSC();
      }));
    } else {
      dataPack["idUser"] = await session.get("idUser");

      Response response = await Dio().post(urlFull, data: dataPack);

      void clearSessionData() async {
        await session.set("idUser", "");
        await session.set("keyAccount", "");
        await session.set("nameFirst", "");
        await session.set("nameLast", "");
        await session.set("phoneNumber", "");
        await session.set("accessStatus", "");
      }

      if (response.statusCode == 200) {
        var data = response.toString();
        if (data == "online") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeSC();
          }));
        } else if (data == "investigate" || data == "offline") {
          clearSessionData();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoginSC();
          }));
        }
      } else if (response.statusCode == 206) {
        clearSessionData();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginSC();
        }));
      }
    }
  }
}
