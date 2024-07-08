
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'model_control.dart';
 class AddOffs extends StatefulWidget {
   const AddOffs({super.key});

   @override
   State<AddOffs> createState() => _AddOffsState();
 }

 class _AddOffsState extends State<AddOffs> {
   late String _name;
   late Uint8List _imageBytes;

   @override
   void initState() {
     super.initState();
     _imageBytes = Uint8List(0);
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

   Future<void> _addOffs() async {
     final offs = Offs(
       id: 0,
       name: _name,
       imageBytes: _imageBytes,
     );
//await Category.addCategory(category);
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
           backgroundColor:Colors.blueGrey,
           title: Text('اضافة عرض'),

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
               ),
               SizedBox(height: 35),
               Container(
                 height: 60,
                 child: ElevatedButton(
                   style:ElevatedButton.styleFrom(
                       elevation: 10,

                       backgroundColor: Colors.blueGrey,
                       shape: RoundedRectangleBorder(
                           side: BorderSide(color: Colors.black26),
                           borderRadius: BorderRadius.circular(30)

                       )
                   ) ,
                   onPressed: _addOffs,
                   child: Text('اضــافـة '),






                 ) ,
               )


             ],
           ),
         ),
       ),
     );
   }
 }

