import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ammar/Login/components/components.dart';
import 'package:ammar/Login/components/under_part.dart';
import 'package:ammar/Login/screens/screens.dart';
import 'package:ammar/Login/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ammar/data/Dataurl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  var isObsecure = true.obs;
  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
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
        return;
      }
        try {
          final url = Uri.parse('${AppData.url}Users/users_rige.php');

          final response = await http.post(
            url,
            body: {
              'name': nameController.text.trim(),
              'email': emailController.text.trim(),
              'password': passwordController.text.trim(),
              'check_email': 'true', // add check_email parameter
            },
          );

          if (response.statusCode == 200) {
            final responseBody = jsonDecode(response.body);
            print('Response from PHP script: $responseBody');
            if (responseBody['email_exists']) {
              Fluttertoast.showToast(
                msg: ' قم بتسجيل الدخول البريد الإلكتروني مسجل بالفعل',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[800],
                textColor: Colors.white,
                fontSize: 16.0,

              );
              setState(() {
                nameController.clear();
                emailController.clear();
                passwordController.clear();
                phoneController.clear();
              });
                Get.to(LoginScreen());

            } else {
              final insertResponse = await http.post(
                url,
                body: {
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'password': passwordController.text.trim(),
                  'phone': phoneController.text.trim(),
                },
              );

              if (insertResponse.statusCode == 200) {
                final insertResponseBody = jsonDecode(insertResponse.body);
                print('Response from PHP script (insert): $insertResponseBody');
                Fluttertoast.showToast(
                  msg: " تمت إضافة حسابك بنجاح",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[800],
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                setState(() {
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  phoneController.clear();
                });
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } else {
                print('Error inserting data: ${insertResponse.statusCode}');
              }
            }
          } else {
            print('Error checking email: ${response.statusCode}');
          }

          // Handle the response here
        } catch (e) {
          // Handle the exception here
          Fluttertoast.showToast(
            msg: 'خطأ: لا يمكن الاتصال بالخادم',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }

    }
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
                  imgUrl: "assets/images/register.png",
                ),
                const PageTitleBar(title: 'انشاء حساب جديد'),
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
                                hintText: "الاسم",
                                icon: Icons.person,
                                 controller: nameController,
                                  validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'الرجاء إدخال الاسم';
                                  }
                                  return null;
                                },
                              ),
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
                              RoundedInputField(
                                  hintText: "رقم الهاتف",
                                  controller: phoneController,
                                  icon: Icons.phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'الرجاء إدخال رقم الهاتف';
                                    } else if (!RegExp(r'^\+?\d{9,}$').hasMatch(value)) {
                                      return 'الرجاء إدخال رقم هاتف صحيح';
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
                              RoundedPasswordField(
                                hintText: "تاكيد كلمة المرور",
                                validator: (value) {
                                  if (value != passwordController.text) {
                                    return 'كلمة المرور غير متطابقة';
                                  }
                                  return null;
                                },
                              ),
                              RoundedButton(text: 'انشاء حساب ', press:_handleSubmit),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "هل لديك حساب؟",
                                navigatorText: "تسجيل الدخول من هنا",
                                onTap: () {
                                  Get.to(LoginScreen());
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}