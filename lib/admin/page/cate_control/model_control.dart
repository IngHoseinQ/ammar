import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../data/Dataurl.dart';
class Category {
  int id;
  String name;
  String description;
  Uint8List imageBytes;
  String? addDate;

  Category({required this.id, required this.name, required this.description, required this.imageBytes, this.addDate});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id:int.parse(json['id'].toString()),
        name: json['name'].toString(),
        description: json['description'].toString(),
        imageBytes:  base64.decode(json['image']) ,
        addDate:json['add_date'].toString(),
    );
  }


  static Future<List<Category>> getCategories() async {
    try {
      var url = '${AppData.url}Admin/cate_get.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Category> categories = data.map<Category>((json) => Category.fromJson(json)).toList();
        return categories;
      } else {

        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Failed to load categories: $error');
    }
  }
  static Future<void> addCategory(Category category) async {
    var url = '${AppData.url}Admin/cate_add.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = category.name;
    request.fields['description'] = category.description;
    request.fields['image'] = base64.encode(category.imageBytes);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to add category');
    }
  }

  static Future<void> updateCategory(Category category) async {
    var url = '${AppData.url}Admin/cate_update.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = category.id.toString();
    request.fields['name'] = category.name;
    request.fields['description'] = category.description;
    request.fields['image'] = base64.encode(category.imageBytes);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  static Future<void> deleteCategory(int categoryId) async {
    var url = '${AppData.url}Admin/cate_delete.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = categoryId.toString();

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}