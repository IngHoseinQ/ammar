import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../cate_control/model_control.dart';
import 'model_control.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late String _name;
  late String _subname;
  late String _type_price;
  late String _description;
  late double _price;
   int _categoryId=1;
  late Uint8List _imageBytes;
  List<Category> _categories = [];
  Future<void> _fetchCategories() async {
    _categories = await Category.getCategories();
    _categories = _categories.toSet().toList(); // إزالة العناصر المكررة
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _type_price='ر.ي';
    _fetchCategories();
    _imageBytes = Uint8List(0);
  }

  void _selectImage() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تحديد صورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('اخذ صورة بالكاميرا'),
              onTap: () async {
                Navigator.of(context).pop();
                await _getImageBytes(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('اختيار صورة من المعرض'),
              onTap: () async {
                Navigator.of(context).pop();
                await _getImageBytes(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageBytes(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _addProduct() async {
    final product = Product(
      id: 0,
      name: _name,
      subname: _subname,
      description: _description,
      price: _price,
      categoryId: _categoryId,
      imageBytes: _imageBytes,
      type_price: _type_price,
    );
    try {
     // await Product.addProduct(product);
      Navigator.of(context).pop(product);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(T);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading:  IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(context).pop(T);
            },
          ),
          backgroundColor: Colors.blueGrey,
          title: Text('اضافة المنتج'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageBytes.isNotEmpty
                      ? Image.memory(
                    _imageBytes,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                ' اسم المنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(

                'اسم اضافي للمنتج',
                style: TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _subname = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                ' وصف المنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'سعر المنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value) ?? 0;
                  });
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

          DropdownButtonFormField<String>(
          value: _type_price,
            items: [
              DropdownMenuItem(
                value: 'ر.ي',
                child: Text('ر.ي'),
              ),
              DropdownMenuItem(
                value: '\$',
                child: Text('\$'),
              ),
              DropdownMenuItem(
                value: 'ر.س',
                child: Text('ر.س'),
              ),
            ],
          onChanged: (value) {
            setState(() {
              _type_price = value!;
            });
          },
        ),
              SizedBox(height: 10),
              Text(
                'اختار الصنف الخاص بالمنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              FutureBuilder<List<Category>>(
                future: Category.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final categories = snapshot.data!;

                  return DropdownButtonFormField<Category>(
                    value: categories.isNotEmpty ? categories[0] : null,
                    onChanged: (Category? value) {
                      setState(() {
                        _categoryId = value!.id;
                      });
                    },
                    items: categories.map<DropdownMenuItem<Category>>((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                      ),
                      labelText: 'الفئة',
                    ),
                  );
                },
              ),
              SizedBox(height: 35),
              Container(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _addProduct,
                  child: Text(' اضافة المنتج'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}