import 'package:ammar/admin/page/cate_control/categoryview.dart';
import 'package:ammar/admin/page/info/info_app.dart';
import 'package:ammar/admin/page/pro_control/prductview.dart';
import 'package:ammar/admin/page/user%20control/view_users.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'page/offs_control/offs_view.dart';
class adm extends StatefulWidget {
  const adm({Key? key}) : super(key: key);

  @override
  State<adm> createState() => _admState();
}

class _admState extends State<adm> {
  String? _Aname;
  String? _Aemail;

  @override
  void initState() {
    super.initState();
    getinfo();
  }

  Future<void> getinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    setState(() {
      _Aname = name;
      _Aemail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("تأكيد الخروج"),
            content: Text("هل أنت متأكد أنك تريد الخروج؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("لا"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("نعم"),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(

          leading: null,
          title: Text('لوحة الادمن'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                    )),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/img_4.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'مرحبا, $_Aname',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'ElMessiri-Bold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'الايميل: $_Aemail',
                          style: TextStyle(
                            fontFamily: 'ElMessiri-Bold',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(

                height: 120,
                child: Card(

                  color: Colors.white10,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: InkWell(
                    onTap: (){
                      Get.to(InfoPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.app_settings_alt, size: 50, color: Colors.red),
                        Text(
                          ' ادارة معلومات التطبيق',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: 'ElMessiri-Bold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: MyGridView(),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}

class MyGridView extends StatelessWidget {


  const MyGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [

        _buildItem(

          icon:Icons.category,
          label: 'ادارة الاقــسـام',
          iconColor:Colors.blue,
          color: Colors.white10,
          onTap:   () {
           Get.to(CategoryList());
          },
        ),
        _buildItem(
          icon: Icons.production_quantity_limits,
          label:  'ادارة المنتجات',
          iconColor: Colors.green,
          color: Colors.white10,
          onTap:    () {
            Get.to(ProductList());
          },
        ),
        _buildItem(
          icon:Icons.local_offer,
          label:  'ادارة العروض',
          color: Colors.white10,
          iconColor:Colors.deepPurple,
          onTap: (){
            Get.to(OffsList());
          },

        ),
        _buildItem(
          label: 'ادارة المستخدمين',
          iconColor: Colors.yellow,
           icon: Icons.person_pin_rounded,
          color: Colors.white10,
          onTap: (){
          Get.to(UsersList());
          },
        ),
      ],
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40)
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 50, color: iconColor),
            Text(
              label,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontFamily: 'ElMessiri-Bold',
              ),
            ),
          ],
        ),
      ),
    );
  }
  }