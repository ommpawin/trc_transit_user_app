//Main Package
import 'package:flutter/material.dart';

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Import Screen
import 'package:trc_transit/screens/send_complaint_screen.dart';

class HistorySC extends StatefulWidget {
  @override
  _HistorySCState createState() => _HistorySCState();
}

class _HistorySCState extends State<HistorySC> {
  bool isTrue = false;

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
                    "ประวัติการใช้บริการ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                    height: 528.0,
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 315.0),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 18.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              "สัปดาห์นี้",
                              style: TextStyle(
                                  color: Color(0xFF868686),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(
                                  width: 3.0,
                                  color: Color(0xC2FFD104),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 28.0,
                                          width: 253.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Icon(
                                                        FontAwesomeIcons.box,
                                                        color:
                                                            Color(0xFFE6BB00),
                                                        size: 13.0),
                                                  ),
                                                  Text(
                                                    "บริการ ส่งพัสดุ",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFE6BB00),
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ]),
                                              ),
                                              Container(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<
                                                                Color>(isTrue ==
                                                                    true
                                                                ? Colors
                                                                    .green[700]
                                                                : Colors
                                                                    .red[800]),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all<Size>(Size(
                                                                50.0, 28.0)),
                                                    padding:
                                                        MaterialStateProperty.all<
                                                                EdgeInsetsGeometry>(
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0)),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                      isTrue == true
                                                          ? "ส่งคำร้องเรียนแล้ว"
                                                          : "ร้องเรียนบริการ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                  onPressed: (() {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return SendComplaintSC();
                                                    }));
                                                  }),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 15.0),
                                          child: Text(
                                              "หางดง - ฟาร์อีสเทอร์น (เที่ยว ขาไป)",
                                              style: TextStyle(
                                                  color: Color(0xFFFFD304),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        Text(
                                            "เรียกใช้บริการเวลา : 04.02 น. (16/04/2564)",
                                            style: TextStyle(
                                                color: Color(0xFFE6BB00),
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w500)),
                                      ])
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(
                                  width: 3.0,
                                  color: Color(0xC2FFD104),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 28.0,
                                          width: 253.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .streetView,
                                                        color:
                                                            Color(0xFFE6BB00),
                                                        size: 13.0),
                                                  ),
                                                  Text(
                                                    "บริการ โดยสาร",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFE6BB00),
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ]),
                                              ),
                                              Container(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .red[800]),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all<Size>(Size(
                                                                50.0, 28.0)),
                                                    padding:
                                                        MaterialStateProperty.all<
                                                                EdgeInsetsGeometry>(
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0)),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text("ร้องเรียนบริการ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                  onPressed: (() {}),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 15.0),
                                          child: Text(
                                              "หางดง - ฟาร์อีสเทอร์น (เที่ยว ขาไป)",
                                              style: TextStyle(
                                                  color: Color(0xFFFFD304),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        Text(
                                            "เรียกใช้บริการเวลา : 03.41 น. (16/04/2564)",
                                            style: TextStyle(
                                                color: Color(0xFFE6BB00),
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w500)),
                                      ])
                                ],
                              ))
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
}
