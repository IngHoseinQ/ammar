import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ammar/data/model/us/users.dart';

class ReUser {

  static Future<void> SaveRU(User Userinfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userjdata = jsonEncode(Userinfo.toJson());
    await preferences.setString("currtuser", userjdata);
  }
  static Future<User?> GetRU() async{
    User? crrentUserInfo;
    SharedPreferences preferences =await SharedPreferences.getInstance();
   String? UserInfo =  preferences.getString("currtuser");
   if(UserInfo!=null){
     Map<String,dynamic> Userdatamap =jsonDecode(UserInfo);
     crrentUserInfo =User.fromJson(Userdatamap);
   }
      return crrentUserInfo;
  }
  static Future<void> RemoveRU() async{
    SharedPreferences preferences =await SharedPreferences.getInstance();
    await preferences.remove("currtuser");
  }
}