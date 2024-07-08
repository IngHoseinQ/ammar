import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../data/Dataurl.dart';
class Offs {
  int id;
  String name;
  Uint8List imageBytes;
  String? addDate;

  Offs({required this.id, required this.name, required this.imageBytes,this.addDate});

  factory Offs.fromJson(Map<String, dynamic> json) {
    return Offs(
      id:int.parse(json['id'].toString()),
      name: json['name'].toString(),
      imageBytes:  base64.decode(json['image']) ,
      addDate:json['add_date'].toString(),
    );
  }


  static Future<List<Offs>> getOffs() async {
    try {
      var url = '${AppData.url}Admin/offs_get.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Offs> offs = data.map<Offs>((json) => Offs.fromJson(json)).toList();
        return offs;
      } else {

        throw Exception('Failed to load offs');
      }
    } catch (error) {
      throw Exception('Failed to load offs: $error');
    }
  }
  static Future<void> addOffs(Offs offs) async {
    var url = '${AppData.url}Admin/offs_add.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = offs.name;
    request.fields['image'] = base64.encode(offs.imageBytes);
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to add offs');
    }
  }

  static Future<void> updateOffs(Offs offs) async {
    var url = '${AppData.url}Admin/offs_update.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = offs.id.toString();
    request.fields['name'] = offs.name;
    request.fields['image'] = base64.encode(offs.imageBytes);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update offs');
    }
  }

  static Future<void> deleteOffs(int offsId) async {
    var url = '${AppData.url}Admin/offs_delete.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = offsId.toString();

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to delete offs');
    }
  }
}