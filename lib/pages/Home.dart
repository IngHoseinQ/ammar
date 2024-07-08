
import 'dart:core';

import 'package:ammar/Login/a.dart';
import 'package:ammar/pages/secreen/Draw//Drower.dart';
import 'package:ammar/pages/secreen/ditpage.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../admin/page/info/info_app.dart';
import '../admin/page/info/model_app.dart';
import '../data/model/us/UserPreferences/currt_user.dart';
import 'package:ammar/data/model/us/users.dart';
import 'package:ammar/pages/secreen/mainpage.dart';
import 'package:ammar/pages/secreen/newpage.dart';
import 'package:ammar/pages/secreen/serchpage.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Crtuser _remper = Get.put(Crtuser());
  late Future<List<Info>> _futureInfo;
  bool _isDarkMode = false;
  static ThemeData? _themeData;

  @override
  void initState() {
    _checknet();
    super.initState();
    _futureInfo = Info.getInfo();
    _loadTheme();
  }


  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    });
  }
void _checknet()async{
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
_showToast('لا يوجد اتصال بالإنترنت', Colors.red);



  }
  }
  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
      _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
      prefs.setBool('isDarkMode', _isDarkMode);
    });
  }

  String dark = "تفعيل الوضع المعتم";
  String light = "تفعيل الوضع الفاتح";

  void _showToast(String message,Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);



  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return GetBuilder(init: Crtuser(),
      initState: (crtuserState) {
        _remper.getUserInfo();
      },
      builder: (controller) {

        return Theme(
          data: _themeData ?? ThemeData.light(),
          child: DefaultTabController(
            animationDuration: Duration(milliseconds: 300),
            length: 3,
            child: Scaffold(
              key: _scaffoldKey,
                drawer: NavBar(),
              appBar: AppBar(
backgroundColor: _isDarkMode ? Colors.grey[900] : kPrimaryColor,
                title: Container(
                  padding: EdgeInsets.only(left:20 ,right:20  ),
child:  FutureBuilder<List<Info>>(
    future: _futureInfo,
    builder: (context, snapshot) {
      if(snapshot.data == null){
        return Text("Ammar Store",style: TextStyle(fontFamily: MyFont),);
      }
       return Text(snapshot.data![0].name,style: TextStyle(fontFamily: MyFont),);

    }), decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color.fromRGBO(24, 24, 24, 80),
                ),
                ),

                centerTitle: true,
                leading: Container(
                  padding: EdgeInsets.only(left:2 ,right:2,top: 0,bottom: 0 ),
                  child:
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  margin: EdgeInsets.only(top: 3,bottom: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color.fromRGBO(24, 24, 24, 80),
                  ),


                ),
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left:2 ,right:2,top: 0,bottom: 0 ),
                    child:
                      IconButton(
                        tooltip: _isDarkMode ? light : dark,
                        icon: _isDarkMode ? Icon(Icons.light_mode) : Icon(
                            Icons.dark_mode),
                        onPressed: () {
                          _toggleTheme();
                        },
                      ),

                    margin: EdgeInsets.only(top: 3,bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color.fromRGBO(24, 24, 24, 80),
                    ),


                  ),

                ],


              ),
              body: TabBarView(

                children: <Widget>[
                  Min(),
                  New(),
                  InfoPagein(),
                ],
              ),

              bottomNavigationBar: ConvexAppBar(
                backgroundColor: _isDarkMode ? Colors.grey[900] : kPrimaryColor,
                color: Colors.white,
                cornerRadius: BorderSide.strokeAlignCenter,
                activeColor: Colors.white,
                style: TabStyle.reactCircle,
                elevation: 6,
                height: 55,
                items: const [
                  TabItem(
                    icon: Icon(Icons.house, color: Colors.white, size: 30),
                    activeIcon: Icon(Icons.home, color: Colors.blue, size: 35),
                    title: 'الرئيسية',fontFamily: MyFont
                  ),
                  TabItem(
                    icon: Icon(
                        Icons.newspaper_sharp, color: Colors.white, size: 30),
                    activeIcon:
                    Icon(Icons.newspaper_sharp, color: Colors.green, size: 35),
                    title: 'الجديد',fontFamily: MyFont
                  ),

                  TabItem(
                    icon: Icon(
                        Icons.info, color: Colors.white, size: 30),
                    activeIcon: Icon(
                        Icons.info, color: Colors.cyan, size: 35),
                    title: 'معلومات التطلبيق',fontFamily: MyFont
                  ),

                ],
                onTap: (int index) {},
              ),
            ),
          ),
        );
      },
    );
  }
}