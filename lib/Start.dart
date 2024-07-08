import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:ammar/Login/a.dart';
import 'package:ammar/Login/screens/login_screen.dart';
import 'package:ammar/Login/screens/signup_screen.dart';

import 'admin/page/info/model_app.dart';
class str extends StatefulWidget {
  const str({super.key});

  @override
  State<str> createState() => _strState();
}

class _strState extends State<str> {
  late Future<List<Info>> _futureInfo;

  @override
  void initState() {

    super.initState();
    _futureInfo = Info.getInfo();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffFFFFFF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/img.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),  Center(
                  child: FutureBuilder<List<Info>>(
                      future: _futureInfo,
                      builder: (context, snapshot) {
                        if(snapshot.data == null){
                          return Image.asset("assets/images/logo.png",
                            width: 150.0,
                            height: 150.0,
                            fit: BoxFit.cover,);
                        }
                        return  Image.memory(
                          snapshot.data![0].imageBytes,
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        );

                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: FutureBuilder<List<Info>>(
                      future: _futureInfo,
                      builder: (context, snapshot) {
                        if(snapshot.data == null){
                          return Text(
                            ' مرحبا بك في تطبيق عمار - ar ستور',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          );
                        }
                        return                   Text(
                          ' مرحبا بك في تطبيق ${snapshot.data![0].name_app}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        );

                      }),

                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:kPrimaryColor,
                      textStyle:  TextStyle(color: Colors.white ,fontFamily: MyFont),
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                       ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {

                  Get.to(()=>LoginScreen());


                    },
                  ),
                ),   Padding(
                  padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:Colors.black,
                      textStyle:  TextStyle(color: Colors.white,fontFamily: MyFont ),
                      padding:  EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side:
                          const BorderSide(color: kPrimaryColor)),
                    ),
                    child:  Text(
                      'أنشئ حساب الأن',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Get.to(()=>SignUpScreen());
                    },
                  ),
                ),
              ],
          ),
      ),
    );
  }
}
