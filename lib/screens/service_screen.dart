//Main Package
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;

//Dependencies Package
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:longdo_maps_flutter/longdo_maps_flutter.dart';

//Import Screen
import 'package:trc_transit/screens/home_screen.dart';

//Import Setting
import 'package:trc_transit/_setting.dart';

class ServiceSC extends StatefulWidget {
  ServiceSC(
      {this.idRoute,
      this.nameRoute,
      this.goStatus,
      this.tripRegister,
      this.serviceType,
      this.carLicenseRegister,
      this.timeStartService,
      this.saveRouteLine,
      this.saveHexColorRouteLine,
      this.lowerPriceSelect,
      this.higherPriceSelect,
      this.locationPinStart,
      this.locationPinEnd});

  final int idRoute;
  final String nameRoute;
  final String goStatus;
  final String tripRegister;
  final String serviceType;
  final String carLicenseRegister;
  final String timeStartService;
  final String saveRouteLine;
  final String saveHexColorRouteLine;
  final int lowerPriceSelect;
  final int higherPriceSelect;
  final Map<String, double> locationPinStart;
  final Map<String, double> locationPinEnd;

  @override
  _ServiceSCState createState() => _ServiceSCState();
}

class _ServiceSCState extends State<ServiceSC> implements MapInterface {
  //Long Do Setup
  MapController map;
  List<Marker> markers = [];
  final mapGlobal = GlobalKey<ScaffoldState>();
  bool thaiChote = false;
  bool traffic = false;
  String nowState = "before_service";

  //Class Variable
  Map<String, String> stateService = {
    "before_service": "รอใช้บริการ",
    "on_service": "ระหว่างใช้บริการ",
    "after_service": "รอสรุปการใช้บริการ"
  };
  Map<String, String> goStatusText = {
    "Forward": "(เที่ยว ขาไป)",
    "Backward": "(เที่ยวขา กลับ)"
  };
  Map<String, String> nameServiceType = {
    "passenger": "โดยสาร",
    "supplies": "ส่งพัสดุ"
  };
  Timer timer;
  bool driverPin = false;
  bool updateDriverLocation = true;
  bool showAlertSuccess = false;
  Map<String, double> driverLocation = {"lon": 0.0, "lat": 0.0};

  @override
  void initState() {
    timer = Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => {
              if (updateDriverLocation == true) {getDriverLoaction()},
              if (nowState != "before_service") {checkEndService()}
            });
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
                            Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  stateService[nowState],
                                  style: TextStyle(
                                      color: Color(0xFF474747),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700),
                                ),
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
                            color: Color(0xFFFFD304),
                          ),
                          child: Icon(FontAwesomeIcons.truck,
                              color: Colors.white, size: 18.0),
                        ),
                        onTap: (() async {
                          var location = await map.currentLocation();
                          if (location != null) {
                            map.go(
                                lon: driverLocation["lon"],
                                lat: driverLocation["lat"]);
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
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
                child: Column(children: <Widget>[
                  textLabel(
                    question: "เส้นทาง",
                    answer:
                        "${widget.nameRoute} ${goStatusText[widget.goStatus]}",
                    bold: true,
                  ),
                  textLabel(
                    question: "ทะเบียนรถบริการ",
                    answer: widget.carLicenseRegister,
                    bold: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: textLabel(
                      question: "ประบริการ",
                      answer: nameServiceType[widget.serviceType],
                      bold: false,
                    ),
                  ),
                  textLabel(
                    question: "ค่าบริการ",
                    answer:
                        "เริ่มต้น ${widget.lowerPriceSelect}฿ | สูงสุด ${widget.higherPriceSelect}฿",
                    bold: false,
                  ),
                  textLabel(
                    question: "เวลาเรียกใช้บริการ",
                    answer: "${widget.timeStartService} น.",
                    bold: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Divider(color: Color(0x8A6E6E6E)),
                  ),
                  nowState == "before_service"
                      ? menuButton(
                          colorMenu: Colors.blue,
                          colorText: Colors.white,
                          nameMenu: "ได้รับการบริการแล้ว",
                          onFunction: (() {
                            showAlertConfirmService(condition: "on_service");
                          }))
                      : nowState == "on_service" &&
                              widget.serviceType == "passenger"
                          ? menuButton(
                              colorMenu: Colors.green,
                              colorText: Colors.white,
                              nameMenu: "สิ้นสุดการบริการ",
                              onFunction: (() {
                                showAlertConfirmService(
                                    condition: "after_service");
                              }))
                          : nowState == "on_service" &&
                                  widget.serviceType == "supplies"
                              ? menuButton(
                                  colorMenu: Colors.grey,
                                  colorText: Colors.white,
                                  nameMenu: "พัสดุอยู่ระหว่างการนำส่ง",
                                )
                              : menuButton(
                                  colorMenu: Colors.grey[800],
                                  colorText: Colors.white,
                                  nameMenu: "รอผลสรุปการใช้บริการ",
                                )
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
            "map.location({lon: ${location.lon},lat: ${location.lat}}, true); map.Ui.Crosshair.visible(false); map.zoom(15, true);");
    getDriverLoaction();
  }

  @override
  void onOverlayClicked(BaseOverlay overlay) {
    if (overlay is Marker) {
      var location = overlay.mapLocation;
      map?.go(lon: location.lon, lat: location.lat);
    }
  }

  Future<dynamic> getSessionValue(key) async {
    dynamic data = await FlutterSession().get(key);
    return data;
  }

  Widget textLabel({String question, String answer, IconData icon, bool bold}) {
    bold ??= false;
    question ??= "";
    answer ??= "";

    FontWeight fontWeight = bold ? FontWeight.w700 : FontWeight.w500;

    return Row(children: <Widget>[
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

  Widget menuButton(
      {Color colorMenu,
      Color colorText,
      @required String nameMenu,
      Function onFunction}) {
    colorMenu ??= Colors.blue;
    colorText ??= Colors.white;
    nameMenu ??= "ชื่อปุ่ม";

    return Container(
      height: 40.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5.0),
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
            child: Text(nameMenu,
                style: TextStyle(
                  color: colorText,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ))),
        onPressed: (() {
          onFunction();
        }),
      ),
    );
  }

  void setPinService({
    String pinType,
    String statusPin,
    double lon,
    double lat,
  }) {
    String urlPin;

    if (pinType == "StartService") {
      urlPin = "https://sv1.picz.in.th/images/2021/04/08/ASbInN.png";
    } else if (pinType == "EndService") {
      urlPin = "https://sv1.picz.in.th/images/2021/04/08/ASjdKQ.png";
    }

    if (statusPin == "startPin") {
      setState(() {
        markers.add(Marker(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          mapLocation: MapLocation(lon: lon, lat: lat),
          url: urlPin,
          height: 28,
          width: 16,
        ));
      });
    } else if (statusPin == "endPin") {
      setState(() {
        markers.add(Marker(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          mapLocation: MapLocation(lon: lon, lat: lat),
          url: urlPin,
          height: 28,
          width: 16,
        ));
      });
    }
  }

  Future<void> getDriverLoaction() async {
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull =
        "$domain/mobile/user_get_driver_location?idRoute=${widget.idRoute}&idTrip=${widget.tripRegister}";

    Response response = await Dio().get(urlFull);

    if (response.statusCode == 200) {
      var data = json.decode(response.toString());

      setDriverLocationNow(lon: data["lon"], lat: data["lat"]);
    }
  }

  void setDriverLocationNow({double lon, double lat}) async {
    if (driverPin == true) {
      if (markers[0] != null) {
        markers?.removeAt(0);
      }
    }

    print("Update Location.");

    driverLocation["lon"] = lon;
    driverLocation["lat"] = lat;

    map.go(lon: lon, lat: lat);

    if (driverPin == false) {
      setState(() {
        driverPin = true;
        markers?.add(
          Marker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            mapLocation: MapLocation(lon: lon, lat: lat),
            url: "https://sv1.picz.in.th/images/2021/04/08/ASMHK1.png",
            width: 46,
            height: 46,
          ),
        );

        setPinService(
            pinType: "StartService",
            statusPin: "startPin",
            lon: widget.locationPinStart["lon"],
            lat: widget.locationPinStart["lat"]);
        setPinService(
            pinType: "EndService",
            statusPin: "endPin",
            lon: widget.locationPinEnd["lon"],
            lat: widget.locationPinEnd["lat"]);

        setRouteLineMap(
            routeLine: widget.saveRouteLine,
            hexColor: widget.saveHexColorRouteLine);
        setBeforeService();
      });
    } else {
      setState(() {
        markers?.insert(
          0,
          Marker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            mapLocation: MapLocation(lon: lon, lat: lat),
            url:
                "https://www.img.in.th/images/b798c964009096f6381f09e44a3c55da.png",
            width: 46,
            height: 46,
          ),
        );
      });
    }
  }

  Future<void> setRouteLineMap({String routeLine, String hexColor}) async {
    setState(() {
      map?.run(
          script:
              'var routeLine = new longdo.Polyline(${routeLine}, {lineWidth: 3, lineColor: "${hexColor}" }); map.Overlays.add(routeLine);');
    });
  }

  Future<void> setBeforeService() async {
    dynamic idUser = await getSessionValue("idUser");
    DateTime timeDevice = DateTime.now();
    String date =
        "${timeDevice.day < 10 ? "0" + timeDevice.day.toString() : timeDevice.day}/${timeDevice.month < 10 ? "0" + timeDevice.month.toString() : timeDevice.month}/${timeDevice.year + 543}";
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull =
        "$domain/mobile/user_before_service?idRoute=${widget.idRoute}&tripService=${widget.tripRegister}&idUser=$idUser&serviceType=${widget.serviceType}";
    var dataPack = Map<String, dynamic>();

    dataPack["date"] = date;
    dataPack["time"] = widget.timeStartService;
    dataPack["startLon"] = widget.locationPinStart["lon"];
    dataPack["startLat"] = widget.locationPinStart["lat"];
    dataPack["endLon"] = widget.locationPinEnd["lon"];
    dataPack["endLat"] = widget.locationPinEnd["lat"];

    Response response = await Dio().put(urlFull, data: dataPack);

    if (response.statusCode == 200) {
      var data = response.toString();

      if (data == "success") {
        setState(() {
          nowState = "before_service";
        });
      }
    }
  }

  Future<void> setOnService() async {
    dynamic idUser = await getSessionValue("idUser");
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull =
        "$domain/mobile/user_on_service?idRoute=${widget.idRoute}&tripService=${widget.tripRegister}&idUser=$idUser";

    Response response = await Dio().put(urlFull);

    if (response.statusCode == 200) {
      var data = response.toString();

      if (data == "success") {
        Navigator.pop(context);
        setState(() {
          nowState = "on_service";
        });
      }
    }
  }

  Future<void> setAfterService() async {
    dynamic idUser = await getSessionValue("idUser");
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull =
        "$domain/mobile/user_after_service?idRoute=${widget.idRoute}&tripService=${widget.tripRegister}&idUser=$idUser";

    Response response = await Dio().put(urlFull);

    if (response.statusCode == 200) {
      var data = response.toString();

      if (data == "success") {
        Navigator.pop(context);
        setState(() {
          nowState = "after_service";
        });
      }
    }
  }

  Future<void> checkEndService() async {
    dynamic idUser = await getSessionValue("idUser");
    String domain = Platform.isAndroid ? setting['urlAPIExternalServer'] : setting['urlAPIServer'];
    String urlFull =
        "$domain/mobile/user_check_end_service?idRoute=${widget.idRoute}&tripService=${widget.tripRegister}&idUser=$idUser";

    Response response = await Dio().get(urlFull);

    if (response.statusCode == 200) {
      var data = response.toString();

      if (data == "end_service") {
        updateDriverLocation = false;
        if (showAlertSuccess == false) {
          showAlertServiceSuccess();
          showAlertSuccess = true;
        }
      }
    }
  }

  void showAlertConfirmService({String condition}) {
    Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(
          color: condition == "on_service"
              ? Colors.blue
              : condition == "after_service"
                  ? Colors.green
                  : "",
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
        descStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: condition == "on_service"
          ? "ยืนยันการได้รับการบริการแล้ว"
          : condition == "after_service"
              ? "ยืนยันสิ้นสุดการใช้บริการ"
              : "",
      desc: condition == "on_service"
          ? "สถานะของคุณจะถูกเปลี่ยนเป็น กำลังใช้บริการ แก่ผู้ขับเมื่อกด ยืนยัน"
          : condition == "after_service"
              ? "สถานะของคุณจะถูกเปลี่ยนเป็น ใช้บริการเสร็จสิ้น แก่ผู้ขับเมื่อกด ยืนยัน"
              : "",
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
          color: condition == "on_service"
              ? Colors.blue
              : condition == "after_service"
                  ? Colors.green
                  : "",
          child: Text(
            "ยืนยัน",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          onPressed: () => {
            condition == "on_service"
                ? setOnService()
                : condition == "after_service"
                    ? setAfterService()
                    : ""
          },
        )
      ],
    ).show();
  }

  void showAlertServiceSuccess() {
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
      title: "สรุปการใช้บริการ ${nameServiceType[widget.serviceType]}",
      desc:
          "การใช้บริการของคุณประเภท ${nameServiceType[widget.serviceType]} เส้นทาง ${widget.nameRoute} ${goStatusText[widget.goStatus]} กับรถ ${widget.carLicenseRegister} สำเร็จ เริ่มใช้บริการเมื่อ ${widget.timeStartService} น. ค่าบริการจากการใช้บริการประเภทของคุณ เริ่มต้น ${widget.lowerPriceSelect} บาท และสูงสุด ${widget.higherPriceSelect} บาท โดยชำระให้แก่ผู้ขับตามจำนวนนี้",
      buttons: [
        DialogButton(
          color: Colors.green,
          child: Text(
            "ตกลง",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          onPressed: () => {
            Navigator.pop(context),
            timer?.cancel(),
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomeSC();
            }))
          },
        )
      ],
    ).show();
  }
}
