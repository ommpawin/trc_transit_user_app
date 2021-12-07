//Main Package
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:longdo_maps_flutter/longdo_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

//Import Screen
import 'package:trc_transit/screens/service_screen.dart';

//Import Setting
import 'package:trc_transit/_setting.dart';

class SelectRouteSC extends StatefulWidget {
  SelectRouteSC({this.serviceType});

  final String serviceType;

  @override
  _SelectRouteSCState createState() => _SelectRouteSCState();
}

class _SelectRouteSCState extends State<SelectRouteSC> implements MapInterface {
  //Long Do Setup
  MapController map;
  List<Marker> markers = [];
  final mapGlobal = GlobalKey<ScaffoldState>();
  bool thaiChote = false;
  bool traffic = false;

  //Class Variable
  Map<String, int> routeID = {};
  List<String> route = [];
  String routeNameSelect = "";
  int routeIdSelect = 0;
  HexColor routeColorSelect = HexColor("#F7B804");
  String routeTimeSelect = "";
  int routeTimeRoundSelect = 0;
  int routeTimeAverageSelect = 0;
  int lowerPriceSelect = 0;
  int higherPriceSelect = 0;

  String tripGoStatus = "รอบเดินรถ เที่ยวขาไป";
  String goStatus = "Forward";

  Map<String, String> serviceName = {
    "passenger": "การโดยสาร",
    "supplies": "การ่งพัสดุ"
  };
  bool servicePin = false;
  Map<String, double> servicePinLocation = {"lon": 0.0, "lat": 0.0};
  Timer timer;
  String saveRouteLine = "";
  String saveHexColorRouteLine = "";
  bool setRouteLine = false;

  @override
  void initState() {
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => getCurrentLocationNow());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9),
      key: mapGlobal,
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                  child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 9.0),
                      color: Color(0xFFFFD304),
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "เลือกเส้นทางใช้บริการ",
                              style: TextStyle(
                                  color: Color(0xFF474747),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  textHeaderTrip(
                                      title: "ประเภทบริการ",
                                      textValue:
                                          serviceName[widget.serviceType]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    LongdoMapView(
                      apiKey: setting["longDoMapAPI"],
                      listener: this,
                      markers: markers,
                    ),
                    Positioned(
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            color: Colors.green,
                          ),
                          child: Icon(FontAwesomeIcons.male,
                              color: Colors.white, size: 18.0),
                        ),
                        onTap: (() async {
                          var location = await map.currentLocation();
                          if (location != null) {
                            map.go(lon: location.lon, lat: location.lat);
                            map.zoom(level: 15, zoom: Zooms.IN, anim: true);
                          }
                        }),
                      ),
                    ),
                  ],
                ),
                flex: 1,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 13.0),
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    "ยกเลิก",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (servicePin == true) {
                                clearEndPin();
                              } else {
                                timer?.cancel();
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        Container(
                            child: servicePin != true
                                ? setPinService()
                                : callService()),
                      ]),
                  Divider(color: Color(0x8A6E6E6E)),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 15.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: textLabel(
                                  question: "ค่าบริการเส้นทาง",
                                  answer:
                                      "เริ่มต้น ${lowerPriceSelect}฿ | สูงสุด ${higherPriceSelect}฿",
                                  bold: true,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  textHeaderTripDetail(
                                      icon: FontAwesomeIcons.clock,
                                      textValue: routeTimeSelect),
                                  textSeparator(),
                                  textHeaderTripDetail(
                                      icon: FontAwesomeIcons.userClock,
                                      textValue: "$routeTimeRoundSelect น."),
                                  textSeparator(),
                                  textHeaderTripDetail(
                                    icon: FontAwesomeIcons.stopwatch,
                                    textValue: "$routeTimeAverageSelect น.",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 56.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: routeColorSelect, width: 4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: routeNameSelect,
                            icon: Icon(FontAwesomeIcons.angleUp),
                            iconSize: 15,
                            underline: Container(
                              color: Colors.white,
                            ),
                            items: route
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                routeIdSelect = routeID[value];
                                routeNameSelect = value;
                                getRoutedetail();
                              });
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            height: 56.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: routeColorSelect, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: tripGoStatus,
                              icon: Icon(FontAwesomeIcons.angleUp),
                              iconSize: 15,
                              underline: Container(
                                color: Colors.white,
                              ),
                              items: <String>[
                                "รอบเดินรถ เที่ยวขาไป",
                                "รอบเดินรถ เที่ยวขากลับ"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  tripGoStatus = value;

                                  if (value == "รอบเดินรถ เที่ยวขาไป") {
                                    goStatus = "Forward";
                                  } else if (value ==
                                      "รอบเดินรถ เที่ยวขากลับ") {
                                    goStatus = "Backward";
                                  }

                                  getRoutedetail();
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                ]),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void onInit(MapController map) async {
    var location = await map.currentLocation();
    this.map = map;
    map.run(
        script:
            "map.location({lon: ${location.lon},lat: ${location.lat}}, true); map.zoom(15, true);");

    setState(() {
      markers.add(Marker(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mapLocation: MapLocation(lon: location.lon, lat: location.lat),
        url: "https://img.in.th/images/4b419985e81fdf141339de851818e49e.png",
        width: 25,
        height: 25,
      ));
    });

    initRouteDetail();
  }

  @override
  void onOverlayClicked(BaseOverlay overlay) {
    if (overlay is Marker) {
      var location = overlay.mapLocation;
      map?.go(lon: location.lon, lat: location.lat);
    }
  }

  void getCurrentLocationNow() async {
    var location = await map.currentLocation();

    if (markers[0] != null) {
      markers?.removeAt(0);
    }

    print("Update Location.");

    if (location != null) {
      setState(() {
        markers?.insert(
          0,
          Marker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            mapLocation: MapLocation(lon: location.lon, lat: location.lat),
            url:
                "https://img.in.th/images/4b419985e81fdf141339de851818e49e.png",
            width: 25,
            height: 25,
          ),
        );
      });
    }
  }

  Widget textHeaderTrip({String title, String textValue}) {
    return Row(children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          title,
          style: TextStyle(
              color: Color(0xFF636363),
              fontSize: 12.0,
              fontWeight: FontWeight.w700),
        ),
      ),
      Text(
        ":",
        style: TextStyle(
            color: Color(0xFF636363),
            fontSize: 12.0,
            fontWeight: FontWeight.w700),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          textValue,
          style: TextStyle(
              color: Color(0xFF636363),
              fontSize: 12.0,
              fontWeight: FontWeight.w400),
        ),
      ),
    ]);
  }

  Widget textHeaderTripDetail({IconData icon, String textValue}) {
    return Row(children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Icon(
          icon,
          color: Color(0xFF2E2E2E),
          size: 11.0,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          textValue,
          style: TextStyle(
              color: Color(0xFF2E2E2E),
              fontSize: 12.0,
              fontWeight: FontWeight.w400),
        ),
      ),
    ]);
  }

  Widget textSeparator() {
    return Text("|",
        style: TextStyle(
            color: Color(0xFF2E2E2E),
            fontSize: 12.0,
            fontWeight: FontWeight.w500));
  }

  Widget textLabel({String question, String answer, IconData icon, bool bold}) {
    bold ??= false;
    question ??= "";
    answer ??= "";

    FontWeight fontWeight = bold ? FontWeight.w700 : FontWeight.w400;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        "$question : ",
        style: TextStyle(fontWeight: fontWeight, fontSize: 13.0),
      ),
      Text(
        answer,
        style: TextStyle(fontWeight: fontWeight, fontSize: 13.0),
      ),
      Text(
        icon != null ? " | " : "",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
      ),
      Icon(
        icon,
        size: 13.0,
      )
    ]);
  }

  Widget setPinService() {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              "เลือกจุดปลายทาง",
              style: TextStyle(
                  color: Colors.yellow[800],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      onTap: () {
        setEndPin();
      },
    );
  }

  Widget callService() {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              "เรียกใช้ใช้บริการ",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      onTap: (() {
        showAlertConfirmCallService();
      }),
    );
  }

  Future<void> initRouteDetail() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull = "$domain/mobile/user_get_all_route";

    Response response = await Dio().get(urlFull);

    if (response.statusCode == 200) {
      var data = json.decode(response.toString());

      data["route"].forEach((element) => {
            route.add(element["nameRoute"]),
            routeID[element["nameRoute"]] = element["idRoute"]
          });

      routeNameSelect = route[0];
      routeIdSelect = routeID[routeNameSelect];
      await getRoutedetail();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> getRoutedetail() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull =
        "$domain/mobile/user_get_route_detail?idRoute=${routeIdSelect}&goStatus=${goStatus}&serviceType=${widget.serviceType}";

    Response response = await Dio().get(urlFull);

    if (response.statusCode == 200) {
      var data = json.decode(response.toString());

      setState(() {
        routeColorSelect = HexColor(data["hexColor"].toString());
        routeTimeSelect =
            "${data["serviceStartTime"]} น. - ${data["serviceEndTime"]} น.";
        routeTimeRoundSelect = data["serviceTimeRound"];
        routeTimeAverageSelect = data["serviceTimeAverage"];
        lowerPriceSelect = data["lowerPrice"];
        higherPriceSelect = data["higherPrice"];
      });
      await setRouteLineMap(
          routeLine: await data["routeLine"], hexColor: await data["hexColor"]);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> setRouteLineMap({String routeLine, String hexColor}) async {
    if (setRouteLine == true) {
      map?.run(script: 'map.Overlays.remove(routeLine);');
    }

    setState(() {
      map?.run(
          script:
              'var routeLine = new longdo.Polyline($routeLine, {lineWidth: 3, lineColor: "${hexColor}" }); map.Overlays.add(routeLine);');
      setRouteLine = true;
      saveRouteLine = routeLine;
      saveHexColorRouteLine = hexColor;
    });
  }

  Future<void> setEndPin() async {
    var mapLocation = await map?.crosshairLocation();

    servicePinLocation["lon"] = mapLocation.lon;
    servicePinLocation["lat"] = mapLocation.lat;

    if (mapLocation != null) {
      setState(() {
        markers?.add(
          Marker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            mapLocation:
                MapLocation(lon: mapLocation.lon, lat: mapLocation.lat),
            url: "https://sv1.picz.in.th/images/2021/04/08/ASjdKQ.png",
            height: 34,
            width: 22,
          ),
        );
        servicePin = true;
      });
    }
  }

  Future<void> clearEndPin() async {
    servicePinLocation["lon"] = 0.0;
    servicePinLocation["lat"] = 0.0;

    setState(() {
      markers?.removeAt(1);
      servicePin = false;
    });
  }

  void showAlertConfirmCallService() {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(
          color: Colors.green,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
        descStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: "คุณต้องการเรียกใช้บริการ",
      buttons: [
        DialogButton(
          color: Color(0xFF6C757D),
          child: Text(
            "ยกเลิก",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
        DialogButton(
          color: Colors.green,
          child: Text(
            "ตกลง",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          onPressed: () => {callStartService()},
        )
      ],
    ).show();
  }

  void showAlertWarning() {
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
        descStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: "ไม่มีรอบเดินรถประจำเส้นทางเดินรถของคุณ",
      buttons: [
        DialogButton(
          color: Color(0xFF6C757D),
          child: Text(
            "ตกลง",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    ).show();
  }

  Future<void> callStartService() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull = "$domain/mobile/user_get_trip_service?idRoute=${routeIdSelect}&goStatus=${goStatus}";

    Navigator.pop(context);
    Response response = await Dio().get(urlFull);

    if (response.statusCode == 200) {
      var data = json.decode(response.toString());
        
      if (data["tripService"] == null) {
        showAlertWarning();
      } else {
        DateTime timeDevice = DateTime.now();
        String time = "${timeDevice.hour < 10 ? "0" + timeDevice.hour.toString() : timeDevice.hour.toString()}:${timeDevice.minute < 10 ? "0" + timeDevice.minute.toString() : timeDevice.minute.toString()}";
        String tripRegister = await data["tripService"];
        String carLicense = await data["carLicense"];
        var location = await map.currentLocation();

        timer?.cancel();
        Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ServiceSC(
              idRoute: routeIdSelect,
              nameRoute: routeNameSelect,
              goStatus: goStatus,
              tripRegister: tripRegister,
              serviceType: widget.serviceType,
              carLicenseRegister: carLicense,
              timeStartService: time,
              saveRouteLine: saveRouteLine,
              saveHexColorRouteLine: saveHexColorRouteLine,
              lowerPriceSelect: lowerPriceSelect,
              higherPriceSelect: higherPriceSelect,
              locationPinStart: {"lon": location.lon, "lat": location.lat},
              locationPinEnd: servicePinLocation,
            );
          }));
      }
    }
  }
}
