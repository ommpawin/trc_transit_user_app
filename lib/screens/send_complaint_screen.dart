//Main Package
import 'package:flutter/material.dart';

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Import Screen
import 'package:trc_transit/screens/home_screen.dart';

class SendComplaintSC extends StatefulWidget {
  @override
  _SendComplaintSCState createState() => _SendComplaintSCState();
}

class _SendComplaintSCState extends State<SendComplaintSC> {
  var nameRoute = TextEditingController();
  var goStatus = TextEditingController();
  var idTrip = TextEditingController();
  var serviceType = TextEditingController();
  var conplaintMassage = TextEditingController();
  var nameUser = TextEditingController();

  @override
  void initState() {
    nameRoute.text = "หางดง - ฟาร์อีสเทอร์น";
    goStatus.text = "เที่ยว ขาไป";
    idTrip.text = "16042564-6-3-F";
    serviceType.text = "ส่งพัสดุ";
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
                    "เขียนคำร้องเรียนบริการ",
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
                            titleInput: "ชื่อเส้นทาง",
                            obscureText: false,
                            hintext: "",
                            controller: nameRoute,
                            readOnly: true,
                          ),
                          inputForm(
                            titleInput: "เที่ยว รอบเดินรถ",
                            obscureText: false,
                            hintext: "",
                            controller: goStatus,
                            readOnly: true,
                          ),
                          inputForm(
                            titleInput: "รหัส รอบเดินรถ",
                            obscureText: false,
                            hintext: "",
                            controller: idTrip,
                            readOnly: true,
                          ),
                          inputForm(
                            titleInput: "คำร้องเรียน / ปัญหาการบริการ",
                            obscureText: false,
                            hintext: "คำร้องเรียน",
                            controller: conplaintMassage,
                            textInputType: TextInputType.datetime,
                            maxLength: 128,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Divider(color: Color(0x8A6E6E6E)),
                          ),
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
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return HomeSC();}));
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
      bool readOnly,
      double heightInput,
      Function onChange,
      Function onTap}) {
    textInputType ??= TextInputType.text;
    maxLength ??= 32;
    readOnly ??= false;

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
            readOnly: readOnly,
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
}
