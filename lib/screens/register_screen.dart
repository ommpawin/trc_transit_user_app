//Main Package
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';

//Import Setting
import 'package:trc_transit/_setting.dart';

class RegisterSC extends StatefulWidget {

  @override
  _RegisterSCState createState() => _RegisterSCState();
}

class _RegisterSCState extends State<RegisterSC> {
  DateTime dateTime;
  DateTime onDatePicker;
  var firstNameInput = TextEditingController();
  var lastNameInput = TextEditingController();
  var dateInput = TextEditingController();
  var phoneNumberInput = TextEditingController();
  var passwordInput = TextEditingController();
  var confirmPasswordInput = TextEditingController();

  @override
  void initState() {
    dateTime = new DateTime.now();
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
              child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.0),
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                        child: GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.chevronLeft,
                                size: 14.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  "กลับ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    "สร้างบัญชีผู้ใช้",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                    constraints: BoxConstraints(maxWidth: 315.0),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 7.0, horizontal: 18.0),
                      child: Column(
                        children: <Widget>[
                          inputForm(
                            titleInput: "ชื่อ",
                            obscureText: false,
                            hintext: "ชื่อ",
                            controller: firstNameInput,
                            textInputType: TextInputType.text,
                            maxLength: 64,
                          ),
                          inputForm(
                            titleInput: "นามสกุล",
                            obscureText: false,
                            hintext: "นามสกุล",
                            controller: lastNameInput,
                            textInputType: TextInputType.text,
                            maxLength: 64,
                          ),
                          inputForm(
                            titleInput: "วัน เดือน ปีเกิด (พ.ศ.)",
                            obscureText: false,
                            hintext: "วัน เดือน ปีเกิด",
                            controller: dateInput,
                            textInputType: TextInputType.datetime,
                            maxLength: 64,
                            onTap: (() {
                              usedatePicker(dateInput);
                            }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Divider(color: Color(0x8A6E6E6E)),
                          ),
                          inputForm(
                              titleInput: "เบอร์โทรศัพท์ (Phone Number)",
                              obscureText: false,
                              hintext: "เบอร์โทรศัพท์",
                              controller: phoneNumberInput,
                              textInputType: TextInputType.number,
                              maxLength: 12,
                              onChange: ((value) {
                                detectPhontNumberPattern(phoneNumberInput);
                              })),
                          inputForm(
                              titleInput: "รหัสผ่าน (Password)",
                              obscureText: true,
                              hintext: "รหัสผ่าน",
                              controller: passwordInput,
                              textInputType: TextInputType.text,
                              maxLength: 32),
                          inputForm(
                              titleInput: "ยืนยันรหัสผ่าน (Confirm-Password)",
                              obscureText: true,
                              hintext: "ยืนยันรหัสผ่าน",
                              controller: confirmPasswordInput,
                              textInputType: TextInputType.text,
                              maxLength: 32),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 9.0),
                                primary: Colors.green, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              icon: Icon(
                                FontAwesomeIcons.save,
                                size: 20.0,
                              ),
                              label: Text("บันทึกข้อมูล",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  )),
                              onPressed: () {
                                verifyForm();
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )),
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
      Function onChange,
      Function onTap}) {
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
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  void usedatePicker(TextEditingController controller) async {
    DateTime dateYearBE = DateTime(DateTime.now().year + 543);

    DateTime getDateTime = await showRoundedDatePicker(
      context: context,
      locale: const Locale("th", "TH"),
      theme: ThemeData(primarySwatch: Colors.yellow, fontFamily: 'Prompt'),
      initialDatePickerMode: DatePickerMode.year,
      initialDate: onDatePicker == null ? dateYearBE : onDatePicker,
      firstDate: DateTime(dateYearBE.year - 99),
      lastDate: dateYearBE,
      borderRadius: 8,
    );

    if (getDateTime != null) {
      onDatePicker = getDateTime;
      controller.text =
          "${getDateTime.toString().substring(8, 10)} / ${getDateTime.toString().substring(5, 7)} / ${getDateTime.toString().substring(0, 4)}";
    }

    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void detectPhontNumberPattern(TextEditingController inputForm) {
    if (inputForm.text.length < 12) {
      inputForm.text = inputForm.text.replaceAll('-', '');
    }

    if (inputForm.text.length == 10 && inputForm.text.length < 11) {
      inputForm.text =
          "${inputForm.text.substring(0, 3)}-${inputForm.text.substring(3, 6)}-${inputForm.text.substring(6, 10)}";
    }

    inputForm.selection =
        TextSelection.fromPosition(TextPosition(offset: inputForm.text.length));
  }

  String passwordEncryption(String password) {
    return md5
        .convert(utf8.encode(password.split('').reversed.join()))
        .toString();
  }

  void verifyForm() {
    bool verify = true;
    List<String> warningTextSet = [];

    FocusScope.of(context).requestFocus(new FocusNode());

    if (firstNameInput.text.trim() == "" ||
        firstNameInput.text.trim().length < 3) {
      warningTextSet.add("ข้อมูลชื่อ");
      verify = false;
    }

    if (lastNameInput.text.trim() == "" ||
        lastNameInput.text.trim().length < 3) {
      warningTextSet.add("ข้อมูลนามสกุล");
      verify = false;
    }

    if (dateInput.text.trim() == "" || dateInput.text.trim().length < 14) {
      warningTextSet.add("ข้อมูลวัน เดือน ปีเกิด");
      verify = false;
    }

    if (phoneNumberInput.text.trim() == "" ||
        phoneNumberInput.text.trim().length < 12) {
      warningTextSet.add("ข้อมูลเบอร์โทรศัพท์");
      verify = false;
    }

    if (passwordInput.text.trim() == "" ||
        passwordInput.text.trim().length < 6) {
      warningTextSet.add("ข้อมูลรหัสผ่าน");
      verify = false;
    }

    if (confirmPasswordInput.text.trim() == "" ||
        confirmPasswordInput.text.trim().length < 6) {
      warningTextSet.add("ข้อมูลยืนยันรหัสผ่าน");
      verify = false;
    } else if (confirmPasswordInput.text.trim() != passwordInput.text.trim()) {
      warningTextSet.add("ข้อมูลรหัสผ่าน และข้อมูลยืนยันรหัสผ่านไม่ตรงกัน");
      confirmPasswordInput.text = "";
      verify = false;
    }

    if (verify == false) {
      showAlertStatusWrong(warningTextSet: warningTextSet);
    } else {
      sendData();
    }
  }

  Future<void> sendData() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull = "$domain/mobile/external_account";
    String dayBirthInput = dateInput.text.trim().substring(0, 2);
    String monthBirthInput = dateInput.text.trim().substring(5, 7);
    String yearBirthInput = dateInput.text.trim().substring(10, 14);
    var dataPack = Map<String, dynamic>();

    dataPack["firstName"] = firstNameInput.text.trim();
    dataPack["lastName"] = lastNameInput.text.trim();
    dataPack["dayBirth"] = dayBirthInput;
    dataPack["monthBirth"] = monthBirthInput;
    dataPack["yearBirth"] = yearBirthInput;
    dataPack["phoneNumber"] = phoneNumberInput.text.trim().replaceAll('-', '');
    dataPack["Password"] = passwordEncryption(confirmPasswordInput.text.trim());

    Response response = await Dio().post(urlFull, data: dataPack);
    print(response.statusCode);

    if (response.statusCode == 200) {
      showAlertStatusWrong(condition: "success");
    } else if (response.statusCode == 206) {
      showAlertStatusWrong(condition: "re-phoneNumber");
    }
  }

  void showAlertStatusWrong({List<String> warningTextSet, String condition}) {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(
          color: condition == "success" 
          ? Colors.green
          : Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
        descStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: condition == "success"
      ? "บัญชีผู้ใช้งานของคุณ พร้อมสำหรับการใช้งานในระบบแล้ว"
      : "พบปัญหาการสร้างบัญชีผู้ใช้",
      desc: condition == null
          ? "โปรดตรวจสอบข้อมูลในช่องกรอกข้อมูลดังนี้ ${warningTextSet.join(', ')} และกดบันทึกข้อมูลใหม่อีกครั้ง"
          :  condition == "re-phoneNumber" 
            ? "เบอร์โทรศัพท์ ${phoneNumberInput.text.trim()} นี้ไม่พร้อมใช้งานในระบบ เนื่องจากมีผู้ใช้งานเบอร์โทรศัพท์นี้ในระบบอยู่แล้ว กรุณาเปลี่ยนแปลงข้อมูล เบอร์โทรศัพท์ และกดบันทึกข้อมูลใหม่อีกครั้ง"
            : condition == "success" 
              ? ""
              : "",
      buttons: [
        DialogButton(
          color: condition == "success"
          ? Colors.green
          : Color(0xFFFFC107),
          child: Text(
            "ตกลง",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => {
            if (condition == "re-phoneNumber") {phoneNumberInput.text = ""}
            else if (condition == "success") {Navigator.pop(context)},
            Navigator.pop(context)
          },
        )
      ],
    ).show();
  }
}
