import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'model_control.dart';
class EditOffs extends StatefulWidget {
  final Offs offs;
 EditOffs({required this.offs});

  @override
  State<EditOffs> createState() => _EditOffsState();
}

class _EditOffsState extends State<EditOffs> {
  late String _name;
  late Uint8List _imageBytes;
  final _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _name = widget.offs.name;
    _imageBytes = widget.offs.imageBytes;
    _nameController.text =_name;
  }
  @override
  void dispose() {
    _nameController.dispose();


    super.dispose();
  }  void _selectImage() async {
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

  Future<void> _updateOffs() async {
    final offs = Offs(
      id: widget.offs.id,
      name: _nameController.text,
      imageBytes: _imageBytes,

    );
//await Category.updateCategory(category);
    Navigator.of(context).pop(offs);
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
            title: Text('تعدبل العرض'),
            backgroundColor: Colors.cyan
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
                      : widget.offs.imageBytes.isNotEmpty
                      ? Image.memory(
                    widget.offs.imageBytes,
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
                'اسم العرض',
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
              SizedBox(height: 35),
              Container(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _updateOffs,
                    style:ElevatedButton.styleFrom(
                        elevation: 10,

                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(30)

                        )
                    ) ,
                    child: Text('تـحديـث البيانات'),

                  )
              )
              ,
            ],
          ),
        ),
      ),
    );
  }
}
