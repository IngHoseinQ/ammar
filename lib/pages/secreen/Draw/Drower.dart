import 'dart:async';

import 'package:ammar/Start.dart';
import 'package:ammar/data/model/us/UserPreferences/User_Preferences.dart';
import 'package:flutter/material.dart';

import 'package:ammar/data/model/us/UserPreferences/currt_user.dart';
import 'package:get/get.dart';
import 'about.dart';
class NavBar extends StatelessWidget {

 final Crtuser _crtuser =Get.put(Crtuser());

  @override

  signoutuser()async
  {
          var resltResbons = await Get.dialog(

             Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),

              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'تأكيد الخروج',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'هل أنت متأكد أنك تريد تسجيل الخروج من التطبيق؟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(width: 32.0),
                            TextButton(
                              onPressed: () async {

                                Get.back(result: "loggedOut");
                              },
                              child: Text(
                                'خروج',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


    );
  if(resltResbons=="loggedOut"){
    ReUser.RemoveRU()
        .then((value){
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('جاري تسجيل الخروج يرجى الانتظار...'),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      Timer(Duration(milliseconds: 1000), () {
        Get.back(); // This will close the dialog
        Get.off(str());
      });
    });
  }
  }
  Widget build(BuildContext context) {

    return Drawer(
      elevation: 4,
      width: 270,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0) ,topLeft:Radius.circular(50.0) ),
     ),
      child: ClipRRect(

        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0) ,topLeft:Radius.circular(50.0) ),
        child: ListView(

          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_crtuser.user.name,style: TextStyle(
                fontFamily: 'Cairo',
              ),),
              accountEmail: Text(_crtuser.user.email,style: TextStyle(
                fontFamily: 'Cairo',
              ),),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/img_4.png',
                    fit: BoxFit.fill,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                //  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(50.0),
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'assets/images/img_3.png',
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.adb_sharp),
              title: Text('مطور التطبيق',style: TextStyle(
                fontFamily: 'Cairo',
              ),),
              onTap: () => showMessageAbout(context),
            ),
            Divider(),
            ListTile(
              title: const Text('تسجيل خروج',style:TextStyle(
                fontFamily: 'Cairo',
              ),),
              leading: Icon(Icons.exit_to_app),
              onTap: () => signoutuser(),
            ),
          ],
        ),
      ),
    );
  }
}