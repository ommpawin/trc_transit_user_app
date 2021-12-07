//Main Package
import 'package:flutter/material.dart';

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//Import Screen
import 'package:trc_transit/screens/login_screen.dart';
import 'package:trc_transit/screens/select_route_screen.dart';
import 'package:trc_transit/screens/history_screen.dart';

class HomeSC extends StatefulWidget {
  @override
  _HomeSCState createState() => _HomeSCState();
}

class _HomeSCState extends State<HomeSC> {
  var session = FlutterSession();
  var userName = "";
  var phoneNumber = "";

  @override
  void initState() {
    setInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD304),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0)),
                color: Color(0xFFF4F6F9),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 4.0),
                            child: textLabel(
                              question: "บัญชี",
                              answer: userName,
                              fontSize: 15.0,
                              bold: true,
                            ),
                          ),
                          textLabel(
                            question: "เบอร์โทรศัพท์",
                            answer: phoneNumber,
                            fontSize: 14.0,
                          ),
                        ],
                      ),
                      Container(
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  color: Color(0xE3DC3546),
                                ),
                                child: Icon(FontAwesomeIcons.signOutAlt,
                                    color: Colors.white, size: 15.0),
                              ),
                              Text(
                                "ออกจากระบบ",
                                style: TextStyle(
                                    color: Color(0xE3DC3546),
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          onTap: (() {
                            showAlertConfirmLogout();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 355.0),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
                  children: <Widget>[
                    menuList(
                        colorMenu: Colors.green,
                        icon: FontAwesomeIcons.streetView,
                        nameMenu: "ใช้บริการโดยสาร",
                        descriptionMenu: "เพื่อโดยสารไปยังปลายทางของท่าน",
                        onFunction: (() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SelectRouteSC(serviceType: "passenger");
                          }));
                        })),
                    menuList(
                        colorMenu: Colors.blue,
                        icon: FontAwesomeIcons.box,
                        nameMenu: "ใช้บริการส่งพัสดุ",
                        descriptionMenu: "เพื่อส่งพัสดุของท่านไปยังปลายทาง",
                        onFunction: (() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SelectRouteSC(serviceType: "supplies");
                          }));
                        })),
                    menuList(
                        colorMenu: Color(0xFF7A8186),
                        icon: FontAwesomeIcons.history,
                        nameMenu: "ประวัติการใช้บริการ",
                        onFunction: (() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HistorySC();
                          }));
                        }))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getSessionValue(key) async {
    dynamic data = await FlutterSession().get(key);
    return data;
  }

  Future<void> setInitData() async {
    String name =
        "คุณ${await getSessionValue("nameFirst")} ${await getSessionValue('nameLast')}";

    userName = name;
    phoneNumber = await getSessionValue("phoneNumber");

    setState(() {});
  }

  Widget textLabel(
      {String question,
      String answer,
      IconData icon,
      bool bold,
      double fontSize}) {
    bold ??= false;
    question ??= "";
    answer ??= "";

    FontWeight fontWeight = bold ? FontWeight.w700 : FontWeight.w500;

    return Row(
      children: <Widget>[
        Text(
          "$question : ",
          style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
        ),
        Text(
          answer,
          style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
        ),
        Text(
          icon != null ? " | " : "",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
        ),
        Icon(
          icon,
          size: 13.0,
        ),
      ],
    );
  }

  Widget menuList(
      {Color colorMenu,
      @required IconData icon,
      @required String nameMenu,
      Color colorNameMenu,
      String descriptionMenu,
      Color colorDescriptionMenu,
      Function onFunction}) {
    colorMenu ??= Colors.blue;
    nameMenu ??= "ชื่อเมนู";
    colorNameMenu ??= Colors.white;
    descriptionMenu ??= "";
    colorDescriptionMenu ??= Color(0xE8FFFFFF);

    return Container(
      height: 85.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorMenu),
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                height: double.infinity,
                margin: EdgeInsets.only(right: 12.0),
                width: 90.0,
                child: Icon(
                  icon,
                  size: 45.0,
                  color: Color(0xE8FFFFFF),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nameMenu,
                      style: TextStyle(
                          color: colorNameMenu,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                    ),
                    descriptionMenu == ""
                        ? Container()
                        : Text(
                            descriptionMenu,
                            style: TextStyle(
                                color: colorDescriptionMenu,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
        onPressed: (() {
          onFunction();
        }),
      ),
    );
  }

  void showAlertConfirmLogout() {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      title: "คุณต้องการออกจากระบบหรือไม่ ?",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "ออกจากระบบ",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          onPressed: () => {singOutSystem()},
        ),
        DialogButton(
          color: Color(0xFF6C757D),
          child: Text(
            "ยกเลิก",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    ).show();
  }

  Future<void> singOutSystem() async {
    await session.set("idUser", "");
    await session.set("keyAccount", "");
    await session.set("nameFirst", "");
    await session.set("nameLast", "");
    await session.set("phoneNumber", "");
    await session.set("accessStatus", "");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginSC();
    }));
  }
}
