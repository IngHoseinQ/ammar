import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'model_control.dart';
import 'categoryview.dart';

class EditCategory extends StatefulWidget {
  final Category category;

  EditCategory({required this.category});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late String _name;
  late String _description;
  late Uint8List _imageBytes;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.category.name;
    _description = widget.category.description;
    _imageBytes = widget.category.imageBytes;

    _nameController.text = _name;
    _descriptionController.text = _description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(' تحديد صورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text(' اخذ صورة بالكيمرا'),
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

  Future<void> _updateCategory() async {
    final category = Category(
      id: widget.category.id,
      name: _nameController.text,
      description: _descriptionController.text,
      imageBytes: _imageBytes,
    );
    //await Category.updateCategory(category);
    Navigator.of(context).pop(category);
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
          centerTitle: true,
          title: Text('تعدبل القـسم'),
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
                      : widget.category.imageBytes.isNotEmpty
                      ? Image.memory(
                    widget.category.imageBytes,
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
                'اسم القـسم',
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
              ),
              SizedBox(height: 10),
              Text(
                maxLines: null,
                'وصف القـسم',
                style: TextStyle(

                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _descriptionController,
              ),
              SizedBox(height: 35),
              Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: _updateCategory,
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('تـحديـث البيانات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}