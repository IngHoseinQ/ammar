import 'package:ammar/pages/secreen/wight_m/viewmin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Login/a.dart';
class Min extends StatefulWidget {
  const Min({super.key});

  @override
  State<Min> createState() => _MinState();
}

class _MinState extends State<Min> {
  bool _isDarkMode = false;
  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData ?? ThemeData.light(),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Container(
              padding: EdgeInsets.only( left: 90 ,right: 170,top: 3,bottom: 3
                 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Text(
                    'الرئيسية',

                    style: TextStyle(
                      color:Colors.white ,
                      fontFamily: MyFont,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Icon(Icons.house,
                    color: Colors.white,


                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: CeremonyHomePage(),
                padding: EdgeInsets.symmetric(horizontal: 2.0),

                decoration: BoxDecoration(

                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

