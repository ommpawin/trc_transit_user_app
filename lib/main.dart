//Main Package
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//Screen
import 'package:trc_transit/screens/export_screen.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRC Trinsit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Prompt',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('en'), const Locale('th', 'TH')],
      initialRoute: '/LoadSC',
      routes: {
        '/LoadSC': (context) => LoadSC(),
        '/LoginSC': (context) => LoginSC(),
        '/HomeSC': (context) => HomeSC(),
        '/SelectRouteSC': (context) => SelectRouteSC(),
        '/ServiceSC': (context) => ServiceSC(),
        '/HistorySC': (context) => HistorySC(),
      },
    );
  }
}
