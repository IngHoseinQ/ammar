import 'dart:async';

import 'package:ammar/Login/widgets/rounded_input_field.dart';
import 'package:ammar/admin/ad_home.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../Login/widgets/rounded_button.dart';
import '../Login/widgets/rounded_password_field.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future <void> gos() async {
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('جاري تسجيل الدخول للادمن...'),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      Timer(Duration(milliseconds: 1000), () {
        Get.back(); // This will close the dialog
        Get.off(adm());
      });

  }
  String user="ahq@#00@";
  String pass="ahq@#00@77777@";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحـكم'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15,right: 15,left: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/img_4.png'),
              ),
              SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    RoundedInputField(
                      hintText: " اليوزر",
                      icon: Icons.person,
                      controller: _usernameController,
                      validator: (value) {
                        if (value !=user) {
                          return '  الرجاء إدخال اليوزرالصحيح';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RoundedPasswordField(
                      hintText: "كلمة المرور",
                      controller: _passwordController,
                      validator: (value) {
                        if (value!=pass) {
                          return 'الرجاء كلمة المرور الصحيحة';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
             RoundedButton(text: 'دخول', press:
                  () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      gos();
                    });

                  }
                },

              ),
            ],
          ),
        ),
      ),
    );
  }
}