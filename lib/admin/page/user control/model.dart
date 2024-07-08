import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../data/Dataurl.dart';
class Users {
  int id;
  String name;
  String email;
  String phone;
  String? addDate;
  Users({required this.id, required this.name, required this.email, required this.phone, this.addDate});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id:int.parse(json['id'].toString()),
      name: json['name'].toString(),
      email: json['email'].toString(),
      phone:  json['phone'].toString() ,
      addDate:json['add_date'].toString(),
    );
  }


  static Future<List<Users>> getUsers() async {
    try {
      var url = '${AppData.url}Admin/Users/get.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Users> users = data.map<Users>((json) => Users.fromJson(json)).toList();
        return users;
      } else {

        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }


  static Future<void> deleteUser(int UserId) async {
    var url = '${AppData.url}Admin/Users/del.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = UserId.toString();

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to delete users');
    }
  }
}
