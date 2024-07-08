import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Login/a.dart';
class Serh extends StatefulWidget {
  const Serh({super.key});

  @override
  State<Serh> createState() => _SerhState();
}

class _SerhState extends State<Serh> {
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
              padding: EdgeInsets.only( left: 90 ,right: 100,top: 3,bottom: 3
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Text(
                    'معلومات التطلبيق',

                    style: TextStyle(
                      color:Colors.white ,

                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Icon(Icons.info,
                    color: Colors.white,


                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),

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


