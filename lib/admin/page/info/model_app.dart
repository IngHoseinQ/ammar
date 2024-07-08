import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../data/Dataurl.dart';
import '../cate_control/model_control.dart';

class Info {
  int id;
  String name;
  String name_app;
  String email;
  String deck;
  String web;
  String phone;
  String adress;
  Uint8List imageBytes;


  Info({
    required this.id,
    required this.name,
    required this.name_app,
    required this.email,
    required this.deck,
    required this.web,
    required this.adress,
    required this.phone,
    required this.imageBytes,

  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      email: json['email'].toString(),
      deck: json['deck'].toString(),
      web: json['web'].toString(),
      adress: json['adress'].toString(),
      imageBytes: base64.decode(json['image']),
      phone: json['phone'].toString(),
      name_app: json['name_app'].toString(),
    );
  }

  static Future<List<Info>> getInfo() async {
    try {
      var url = '${AppData.url}Admin/Info/get.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Info> info = data.map<Info>((json) => Info.fromJson(json))
            .toList();
        return info;
      } else {
        throw Exception('Failed to load Info');
      }
    } catch (error) {
      throw Exception('Failed to load Info: $error');
    }
  }
  static Future<void> updateInfo(Info info) async {
    var url = '${AppData.url}Admin/Info/update.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = info.id.toString().toString();
    request.fields['name'] = info.name.toString();
    request.fields['name_app'] = info.name_app.toString();
    request.fields['email'] = info.email.toString();
    request.fields['web'] = info.web.toString();
    request.fields['phone'] = info.phone.toString();
    request.fields['deck'] = info.deck.toString();
    request.fields['adress'] = info.adress.toString();
    request.fields['image'] = base64.encode(info.imageBytes);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }
}