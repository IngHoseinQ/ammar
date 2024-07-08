import 'package:ammar/admin/login_admin.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ammar/Login/components/components.dart';
import 'package:ammar/Login/components/under_part.dart';
import 'package:ammar/Login/screens/screens.dart';
import 'package:ammar/Login/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ammar/pages/Home.dart';
import 'package:ammar/data/Dataurl.dart';
import 'package:ammar/data/model/us/UserPreferences/User_Preferences.dart';
import 'package:ammar/data/model/us/users.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  var isObsecure = true.obs;
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: 'لا يوجد اتصال بالإنترنت',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      }else{
        try {




          final loginUrlad = Uri.parse('${AppData.url}Admin/admin_log.php');
          final loginadResponse = await http.post(
            headers:{ "Accept": "application/json" } ,
            loginUrlad,
            body: {
              'email': emailController.text.trim(),
              'password': passwordController.text.trim(),
            },
          );
          final loginUrl = Uri.parse('${AppData.url}Users/users_log.php');
          final loginResponse = await http.post(
            loginUrl,
            body: {
              'email': emailController.text.trim(),
              'password': passwordController.text.trim(),
              'check_login': 'true',
            },
          );
          if(loginadResponse.statusCode == 200){
            final responseBody = jsonDecode(loginadResponse.body);
            if (responseBody['log_success']) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('email',emailController.text);
              await prefs.setString('name',responseBody['nameadmin']);

              Get.dialog(
                Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text('مرحيا عزيزي الادمن جاري تسجيل دخولك ...'),
                      ],
                    ),
                  ),
                ),
                barrierDismissible: false,
              );
              Timer(Duration(milliseconds: 1000), () {
                Get.back(); // This will close the dialog
                Get.off(AdminLoginPage());
              });
            }
          }
          if (loginResponse.statusCode == 200) {
            final responseBody = jsonDecode(loginResponse.body);
            if (responseBody['login_success']) {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.setString('email',emailController.text);
              //  await prefs.setBool('isLogged', true);
              User  Userinfo =  User.fromJson(responseBody['userData']);
              await ReUser.SaveRU(Userinfo);
              Get.dialog(
                Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text('جاري تسجيل الدخول يرجى الانتظار...'),
                      ],
                    ),
                  ),
                ),
                barrierDismissible: false,
              );
              Timer(Duration(milliseconds: 1000), () {
                Get.back(); // This will close the dialog
                Get.off(HomeScreen());
              });
            } else {
              // Show error message
              Fluttertoast.showToast(
                msg: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[800],
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          // Handle the response here
        } catch (e) {
          // Handle the exception here
          Fluttertoast.showToast(
            msg: e.toString()+'خطأ: لا يمكن الاتصال بالخادم',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print(e.toString());
        }
      }
    }
  }
  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/login.png",
                ),
                const PageTitleBar(title: 'تسجيل الدخول إلى حسابك'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              RoundedInputField(
                                  hintText: "الايميل",
                                  controller: emailController,
                                  icon: Icons.email,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'الرجاء إدخال بريد إلكتروني';
                                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'الرجاء إدخال بريد إلكتروني صحيح';
                                    }
                                    return null;
                                  }
                              ),
                              RoundedPasswordField(
                                hintText: "كلمة المرور",
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RoundedButton(text: 'دخول', press: _handleSubmit),
                              const SizedBox(
                                height: 20,
                              ),
                              UnderPart(
                                title: "ليس لديك حساب؟",
                                navigatorText: "سجل هنا",
                                onTap: () {
                                  Get.to(SignUpScreen());
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              const SizedBox(height: 172,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



