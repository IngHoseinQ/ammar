import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'model_app.dart';

class EditInfo extends StatefulWidget {
  final Info info;

  EditInfo({required this.info});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  late String _name;
  late String _name_app;
  late String _email;
  late String _deck;
  late String _web;
  late String _phone;
  late String _address;
  late Uint8List _imageBytes;
  final _nameController = TextEditingController();
  final _nameAppController = TextEditingController();
  final _emailController = TextEditingController();
  final _deckController = TextEditingController();
  final _webController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.info.name;
    _name_app = widget.info.name_app;
    _email = widget.info.email;
    _deck = widget.info.deck;
    _web = widget.info.web;
    _phone = widget.info.phone;
    _address = widget.info.adress;
    _imageBytes = widget.info.imageBytes;
    _nameController.text = _name;
    _nameAppController.text = _name_app;
    _emailController.text = _email;
    _deckController.text = _deck;
    _webController.text = _web;
    _phoneController.text = _phone;
    _addressController.text = _address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameAppController.dispose();
    _emailController.dispose();
    _deckController.dispose();
    _webController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختيار صورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('التقاط صورة'),
              onTap: () async {
                Navigator.of(context).pop();
                await _getImageBytes(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('اختيار من المعرض'),
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

  Future<void> _updateInfo() async {
    final info = Info(
      id: widget.info.id,
      name: _nameController.text,
      name_app: _nameAppController.text,
      email: _emailController.text,
      deck: _deckController.text,
      web: _webController.text,
      phone: _phoneController.text,
      adress: _addressController.text,
      imageBytes: _imageBytes,
    );
    Navigator.of(context).pop(info);
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
          title: Text('معلومات التطبيق'),
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
                      : widget.info.imageBytes.isNotEmpty
                      ? Image.memory(
                    widget.info.imageBytes,
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
                'الاسم',
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
                'اسم التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _name_app = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _nameAppController,
              ),
              SizedBox(height: 10),
              Text(
                'البريد الإلكتروني',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _emailController,
              ),
              SizedBox(height: 10),
              Text(
                'الوصف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _deck = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _deckController,
              ),
              SizedBox(height: 10),
              Text(
                'الموقع الإلكتروني',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _web = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _webController,
              ),
              SizedBox(height: 10),
              Text(
                'رقم الهاتف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _phoneController,
              ),
              SizedBox(height: 10),
              Text(
                'العنوان',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _addressController,
              ),
              SizedBox(height: 10),
              SizedBox(height: 35),
              Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: _updateInfo,
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('تحديث المعلومات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}