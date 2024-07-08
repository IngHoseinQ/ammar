import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'Add.dart';
import 'Edit.dart';
import 'model_control.dart';

class OffsList extends StatefulWidget {
  @override
  _OffsListState createState() => _OffsListState();
}

class _OffsListState extends State<OffsList> {
  late Future<List<Offs>> _futureOffs;
  String _searchText = '';
  late bool _isOne = false;
  late bool off=false;
  int ch_ls=2;
  late int count=0;
  @override
  void initState() {
    super.initState();
    off;
    _futureOffs = Offs.getOffs();
  }
  Future<void> ch()async{
    if(_isOne ==false ){
      setState(() {
        _isOne=true;
        ch_ls=1;
      });
    }else{
      setState(() {
        _isOne=false;
        ch_ls=2;
      });
    }
  }
  Future<void> _addOffs() async {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('جاري الااضافة يرجى الانتظار...'),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
    final result = await Get.to(() => AddOffs());
    if(result == T){
      Get.back();
    }else
    if (result != null) {
      await Offs.addOffs(result);
      Fluttertoast.showToast(
        msg: 'تمت عملية الااضافة بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back();
      setState(() {
        _futureOffs = Offs.getOffs();
      });
    }
  }

  Future<void> _updateOffs(Offs offs) async {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('جاري التعديل يرجى الانتظار...'),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
    final result = await Get.to(() => EditOffs(offs: offs));
    if(result == T){
      Get.back();
    }else
    if (result != null) {
      await Offs.updateOffs(result);
      Fluttertoast.showToast(
        msg: 'تمت عملية التعديل بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back();
      setState(() {
        _futureOffs = Offs.getOffs();
      });
    }
  }

  Future<void> _deleteOffs(int offsId) async {
    await Offs.deleteOffs(offsId);
    Fluttertoast.showToast(
      msg: 'تم حذف العرض بنجاح',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      _futureOffs = Offs.getOffs();
    });
  }

  Widget _buildOffsCard(Offs offs) {
    Del()async {
      var resltResbons = await Get.dialog(

        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),

          child: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.blueAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تأكيد الحذف',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'هل أنت متأكد أنك تريد حذف العرض؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(width: 32.0),
                        TextButton(
                          onPressed: () async {

                            Get.back(result: "Delete");
                          },
                          child: Text(
                            'حـذف',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),


      );
      if(resltResbons=="Delete"){
        _deleteOffs(int.parse(offs.id.toString()))
            .then((value){
          Get.dialog(
            Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text('جاري حذف يرجى الانتظار...'),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );

          Timer(Duration(milliseconds: 1000), () {
            Get.back(); // This will close the dialog

          });
        });
      }
    }

    return GestureDetector(
      onTap: () {
// عرض تفاصيل الفئة
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.memory(
                  offs.imageBytes
                  ,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                offs.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                offs.addDate!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.edit,color: Colors.blue),
                  onPressed: () {
                    _updateOffs(offs);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete,color: Colors.red),
                  onPressed:()=>Del(),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(' ادرة العروض - ( '+count.toString()+' )'),
        actions: [
          IconButton(
            icon: _isOne ? Icon(Icons.grid_view_sharp) : Icon(
                Icons.menu),
            onPressed: (){

              ch();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              autofocus: off,
              decoration: InputDecoration(
                hintText: 'ابحــث هنا...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureOffs = Offs.getOffs();
                });
              },
              child: FutureBuilder<List<Offs>>(
                future: _futureOffs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Offs> offeres = snapshot.data!;
                    if (_searchText.isNotEmpty) {
                      offeres = offeres.where((offers) =>
                          offers.name.toLowerCase().contains(_searchText.toLowerCase())
                      ).toList();
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: offeres.length,
                      itemBuilder: (context, index) {
                          count =offeres.length;

                        return _buildOffsCard(offeres[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return  RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _futureOffs = Offs.getOffs();
                          });
                        },
                        child: Center(child: Text('Error: خطا في جلب البيانات تحقق من الاتصال بالانترنت')));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addOffs,
      ),
    );
  }
}

