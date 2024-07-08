import 'package:ammar/admin/page/cate_control/categoryview.dart';
import 'package:ammar/data/model/us/UserPreferences/User_Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:ammar/pages/Home.dart';
import 'package:ammar/Start.dart';

import 'Login/a.dart';
import 'admin/ad_home.dart';
import 'admin/page/offs_control/offs_view.dart';
import 'admin/page/pro_control/prductview.dart';

void main() async {
  kPrimaryColor;
  MyFont;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the default font for the app

        primaryColor: kPrimaryColor,

        fontFamily: MyFont,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English language
        Locale('ar', ''), // Arabic language
      ],
      locale: Locale('ar', ''), // Set the selected language
      home: FutureBuilder(
        future: ReUser.GetRU(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {

            return str();
          } else {
                return HomeScreen();

          }
        },
      ),
    );
  }
}