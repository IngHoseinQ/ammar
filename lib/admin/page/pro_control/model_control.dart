import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../data/Dataurl.dart';
import '../cate_control/model_control.dart';

class Product {
  int id;
  String name;
  String subname;
  String description;
  double price;
  String type_price;
  int categoryId;
  String? categoryName;
  Uint8List imageBytes;
  DateTime? addDate;

  Product({
    required this.id,
    required this.name,
    required this.type_price,
    required this.subname,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageBytes,
    this.categoryName,
    this.addDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      subname: json['subname'].toString(),
      description: json['description'].toString(),
      price: double.parse(json['price'].toString()),
      categoryName: json['categoryName'].toString(),
      categoryId: int.parse(json['category_id'].toString()),
      imageBytes: base64.decode(json['image']),
      addDate: json['add_date'] != null ? DateFormat('yyyy-MM-dd').parse(json['add_date']) : null,
      type_price: json['type_price'].toString(),
    );
  }
  static Future<List<Product>> getNewProducts() async {
    try {
      var url = '${AppData.url}Admin/new_product.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Product> products = data.map<Product>((json) => Product.fromJson(json)).toList();
        for (final product in products) {
          var category = await getCategoryById(product.categoryId);
          product.categoryName = category.name;
        }
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }
  static Future<List<Product>> getProducts() async {
    try {
      var url = '${AppData.url}Admin/product_get.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Product> products = data.map<Product>((json) => Product.fromJson(json)).toList();
        for (final product in products) {
          var category = await getCategoryById(product.categoryId);
          product.categoryName = category.name;
        }
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }
  static Future<List<Product>> getAllProductsByCategoryId(int categoryId) async {
    try {
      var url = '${AppData.url}Admin/product_get_by_category.php';
      var body = {'category_id': categoryId.toString()};
      var response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Product> products = data.map<Product>((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
  static Future<Product> getProductById(int id) async {
    try {
      var url = '${AppData.url}Admin/product_get_by_id.php?id=$id';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          throw Exception('Product not found');
        }
        Product product = Product.fromJson(data);
        var category = await getCategoryById(product.categoryId);
        product.categoryName = category.name;
        return product;
      } else {
        throw Exception('Failed to load product');
      }
    } catch (error) {
      throw Exception('Failed to load product: $error');
    }
  }



  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      var url = '${AppData.url}Admin/product_get_by_category.php?category_id=$categoryId';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data == null) {
          return [];
        }
        List<Product> products = data.map<Product>((json) => Product.fromJson(json)).toList();
        for (final product in products) {
          product.categoryName = await getCategoryNameByCategoryId(product.categoryId);
        }
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  static Future<Category> getCategoryById(int id) async {
    try {
      var url = '${AppData.url}Admin/cate_get_by_id.php?id=$id';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body)['data'];
        if (data == null) {
          throw Exception('Category not found');
        }
        if (data is List) {
          data = data.first;
        }
        Category category = Category.fromJson(data);
        return category;
      } else {
        throw Exception('Failed to load category');
      }
    } catch (error) {
      throw Exception('Failed to load category: $error');
    }
  }

  static Future<String> getCategoryNameByCategoryId(int categoryId) async {
    try {
      var url = '${AppData.url}Admin/cate_get_by_id.php?id=$categoryId';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body)['data'];
        if (data == null) {
          throw Exception('Category not found');
        }
        if (data is List) {
          data = data.first;
        }
        Category category = Category.fromJson(data);
        return category.name;
      } else {
        throw Exception('Failed to load category');
      }
    } catch (error) {
      throw Exception('Failed to load category: $error');
    }
  }

  static Future<void> addProduct(Product product) async {
    var url = '${AppData.url}Admin/product_add.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = product.name;
    request.fields['subname'] = product.subname;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toStringAsFixed(2);
    request.fields['category_id'] = product.categoryId.toString();
    request.fields['type_price'] = product.type_price.toString();
    request.fields['image'] = base64.encode(product.imageBytes);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }

  static Future<void> updateProduct(Product product) async {
    var url = '${AppData.url}Admin/product_update.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = product.id.toString();
    request.fields['name'] = product.name;
    request.fields['subname'] = product.subname;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toStringAsFixed(2);
    request.fields['category_id'] = product.categoryId.toString();
    request.fields['type_price'] = product.type_price.toString();
    request.fields['image'] = base64.encode(product.imageBytes);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  static Future<void> deleteProduct(int productId) async {
    var url = '${AppData.url}Admin/product_delete.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = productId.toString();

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}