//Main Package
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io' show Platform;

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';

//Import Screen
import 'package:trc_transit/screens/home_screen.dart';
import 'package:trc_transit/screens/register_screen.dart';

//Import Setting
import 'package:trc_transit/_setting.dart';

class LoginSC extends StatefulWidget {
  @override
  _LoginSCState createState() => _LoginSCState();
}

class _LoginSCState extends State<LoginSC> {
  var session = FlutterSession();
  var phoneNumberInput = TextEditingController();
  var passwordInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD304),
      body: GestureDetector(
        onTap: () => {FocusScope.of(context).requestFocus(new FocusNode())},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      "assets/images/TRC_Transit.png",
                      width: 200.0,
                    ),
                  ),
                  Container(
                      child: GestureDetector(
                    onTap: () =>
                        {FocusScope.of(context).requestFocus(new FocusNode())},
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 315.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 7.0, horizontal: 18.0),
                            child: Column(
                              children: <Widget>[
                                inputForm(
                                  titleInput: "เบอร์โทรศัพท์ บัญชีผู้ใช้",
                                  obscureText: false,
                                  hintext: "เบอร์โทรศัพท์",
                                  controller: phoneNumberInput,
                                  textInputType: TextInputType.number,
                                  maxLength: 12,
                                  onChange: ((value) {
                                    detectPhontNumberPattern(phoneNumberInput);
                                  }),
                                ),
                                inputForm(
                                    titleInput: "รหัสผ่าน (Password)",
                                    obscureText: true,
                                    hintext: "รหัสผ่าน",
                                    controller: passwordInput,
                                    textInputType: TextInputType.text,
                                    maxLength: 32),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.0, vertical: 9.0),
                                      primary: Color(0xFF007BFF), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.signInAlt,
                                      size: 20.0,
                                    ),
                                    label: Text("เข้าสู่ระบบ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        )),
                                    onPressed: () {
                                      userrAccessSystem();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: 300.0,
                    child: TextButton(
                      style: ButtonStyle(enableFeedback: true),
                      child: Text(
                        "ยังไม่มีบัญชี สำหรับใช้งาน ?",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: (() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterSC();
                        }));
                      }),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          "TRC Transit | TRC Tracking System",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
          ),
        ),
      ),
    );
  }

  Widget inputForm(
      {String titleInput,
      bool obscureText,
      String hintext,
      TextEditingController controller,
      TextInputType textInputType,
      int maxLength,
      Function onChange}) {
    textInputType ??= TextInputType.text;
    maxLength ??= 32;

    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
          child: Text(
            titleInput,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 37.0,
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            style: TextStyle(
              fontFamily: "Prompt",
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF343A40),
            ),
            keyboardType: textInputType,
            maxLength: maxLength,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 13.0),
              counterText: "",
              hintText: hintext,
              hintStyle: TextStyle(color: Color(0xFF979797)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Color(0xFF979797), width: 0.6)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Color(0xFF007bff), width: 0.6)),
            ),
            onChanged: onChange,
          ),
        ),
      ],
    );
  }

  String passwordEncryption(String password) {
    return md5
        .convert(utf8.encode(password.split('').reversed.join()))
        .toString();
  }

  Future<void> userrAccessSystem() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull = "$domain/mobile/userLogin";
    var dataPack = Map<String, dynamic>();

    if (phoneNumberInput.text != "" && passwordInput.text != "") {
      dataPack["phoneNumber"] = phoneNumberInput.text.replaceAll('-', '');
      dataPack["password"] = passwordEncryption(passwordInput.text);

      Response response = await Dio().post(urlFull, data: dataPack);

      if (response.statusCode == 200) {
        var data = json.decode(response.toString());

        if (data['accessStatus'] == "offline") {
          showAlertStatusWrong("offline");
        } else if (data['accessStatus'] == "investigate") {
          showAlertStatusWrong("investigate");
        } else if (data['accessStatus'] == "online") {
          await session.set("idUser", data['idUser']);
          await session.set("keyAccount", data['keyAccount']);
          await session.set("nameFirst", data['nameFirst']);
          await session.set("nameLast", data['nameLast']);
          await session.set("phoneNumber", data['phoneNumber']);
          await session.set("accessStatus", data['accessStatus']);
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return HomeSC();}));
        }
      } else if (response.statusCode == 206 || response.statusCode == 205) {
        if (response.data.toString() == "re-Id") {
          showAlertStatusWrong("reId");
        } else if (response.data.toString() == "re-Password") {
          showAlertStatusWrong("rePassword");
        } else if (response.data.toString() == "re-Send") {
          showAlertStatusWrong("reSend");
        }
      }
    }
  }

  void detectPhontNumberPattern(TextEditingController inputForm) {
    if (inputForm.text.length < 12) {
      inputForm.text = inputForm.text.replaceAll('-', '');
    }

    if (inputForm.text.length == 10) {
      inputForm.text =
          "${inputForm.text.substring(0, 3)}-${inputForm.text.substring(3, 6)}-${inputForm.text.substring(6, 10)}";
    }

    inputForm.selection =
        TextSelection.fromPosition(TextPosition(offset: inputForm.text.length));
  }

  void showAlertStatusWrong(condition) {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
        descStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: "พบปัญหาการเข้าสู่ระบบ",
      desc: condition == "investigate"
          ? "บัญชีผู้ขับของคุณถูก ระงับการใช้งานชั่วคราว โปรดติดต่อผู้ดูแลระบบเพื่อเปลี่ยนแปลงสถานะบัญชีผู้ใช้งานของคุณ และลงชื่อเข้าใช้งานอีกครั้ง"
          : condition == "offline"
              ? "บัญชีผู้ขับของคุณถูก ยกเลิกการใช้งาน จากระบบ"
              : condition == "reId"
                  ? "ไม่พบ รหัสบัญชีผู้ขับ ของคุณในระบบ"
                  : condition == "rePassword"
                      ? "รหัสผ่าน ของคุณไม่ถูกต้อง"
                      : condition == "reSend"
                          ? "ไม่พบ Server ที่ให้บริการหรือ Server อาจกำลังหยุดให้บริการชั่วคราว"
                          : "",
      buttons: [
        DialogButton(
          color: Color(0xFFFFC107),
          child: Text(
            "ตกลง",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => {
            if (condition == "investigate")
              {passwordInput.text = ""}
            else if (condition == "offline")
              {phoneNumberInput.text = "", passwordInput.text = ""}
            else if (condition == "reId")
              {phoneNumberInput.text = "", passwordInput.text = ""}
            else if (condition == "rePassword")
              {passwordInput.text = ""},
            Navigator.pop(context)
          },
        )
      ],
    ).show();
  }
}
