import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'model_control.dart';
import 'prductview.dart';
import '../cate_control/model_control.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  EditProduct({required this.product});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late String _name;
  late String _subname;
  late String _description;
  late String _type_price;
  late double _price;
  late Uint8List _imageBytes;
  late int _categoryId;
  final _nameController = TextEditingController();
  final _subnameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _type_priceController =TextEditingController();
  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _subname=widget.product.subname;
    _description = widget.product.description;
    _price = widget.product.price;
    _type_price =widget.product.type_price;
    _imageBytes = widget.product.imageBytes;
    _categoryId = widget.product.categoryId;
    /////////////////////////////////////////////
    _nameController.text = _name;
    _subnameController.text=_subname;
    _type_priceController.text =_type_price;
    _descriptionController.text = _description;
    _priceController.text=_price.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subnameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    super.dispose();
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
  Future<void> _updateProduct() async {
    final product = Product(
      id: widget.product.id,
      name: _nameController.text,
      subname: _subnameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageBytes: _imageBytes,
      categoryId: _categoryId,
      type_price: _type_priceController.text,
    );
    //await Product.updateProduct(product);
    Navigator.of(context).pop(product);
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
          title: Text('تعديل المنتج'),
          backgroundColor: Colors.cyan,
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
                      : widget.product.imageBytes.isNotEmpty
                      ? Image.memory(
                    widget.product.imageBytes,
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
                'اسم المنتج',
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
                controller: _nameController,
              ), SizedBox(height: 10),
              Text(
                'اسم المنتج الاضافي',
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
                controller: _subnameController,
              ),
              SizedBox(height: 5),
              Text(
                'وصف المنتج',
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
                controller:_descriptionController,
              ),
              SizedBox(height: 5),
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
                    _price = double.tryParse(value) ?? _price;
                  });
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                ),
                controller: _priceController,

              ),
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _type_priceController.text,
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
                    _type_priceController.text = value!;
                  });
                },
              ),
              SizedBox(height: 5),
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
                  return DropdownButtonFormField<int>(
                    value: _categoryId,
                    onChanged: (value) {
                      setState(() {
                        _categoryId = value ?? 0;
                      });
                    },
                    items: categories.map<DropdownMenuItem<int>>((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blueGrey, width: 2.0),
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
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'حفظ التعديلات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}