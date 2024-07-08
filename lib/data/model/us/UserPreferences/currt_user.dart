// ignore_for_file: prefer_final_fields

import 'package:ammar/data/model/us/users.dart';
import 'package:get/get.dart';

import 'package:ammar/data/model/us/UserPreferences/User_Preferences.dart';

class Crtuser extends GetxController{
  Rx<User> _rxuser= User(0,'','', '','',).obs;

User get user => _rxuser.value;

getUserInfo()async{
  User? getuserIFLS = await ReUser.GetRU();
  _rxuser.value =getuserIFLS!;
}

}
