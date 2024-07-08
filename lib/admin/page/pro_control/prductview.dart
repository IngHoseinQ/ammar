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

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Product>> _futureProducts;
  String _searchText = '';
  late int count=0;
  late bool off=false;
  late bool _isOne = false;
  int ch_ls=2;
  @override
  void initState() {
    super.initState();
    off;
    _futureProducts = Product.getProducts();
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
  Future<void> _addProduct() async {
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
    final result = await Get.to(() => AddProduct());
    if(result == T){
      Get.back();
    }else
    if (result != null) {
      await Product.addProduct(result);
      Fluttertoast.showToast(
        msg: 'تمت الإضافة بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back();
      setState(() {
        _futureProducts = Product.getProducts();
      });
    }else{

      Fluttertoast.showToast(
        msg: 'اكمل ادخال البيانات',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _updateProduct(Product product) async {
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
    final result = await Get.to(() => EditProduct(product: product));
    if(result == T){
      Get.back();
    }else
    if (result != null) {
      await Product.updateProduct(result);
      Fluttertoast.showToast(
        msg: 'تم التعديل بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back();
      setState(() {
        _futureProducts = Product.getProducts();
      });
    }else{
      Fluttertoast.showToast(
        msg: 'اكمل ادخال البيانات',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _deleteProduct(int productId) async {
    await Product.deleteProduct(productId);
    Fluttertoast.showToast(
      msg: 'تم الحذف بنجاح',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      _futureProducts = Product.getProducts();
    });
  }

  Widget _buildProudectCard(Product product) {
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
                    'هل أنت متأكد أنك تريد حذف المنتج؟',
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
        _deleteProduct(int.parse(product.id.toString()))
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

                  product.imageBytes
                   ,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'الاسم : '+ product.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'الوصف : '+ product.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'السعر : '+  product.price.toString()+' '+product.type_price,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'تابع لصنف : '+ product.categoryName!,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.addDate!.toString(),
                style: TextStyle(
                  fontSize: 15,
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
                    _updateProduct(product);
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
        title: Text('  ادرة المنـتـجـات - ( '+count.toString()+' )'),
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
                  _futureProducts = Product.getProducts();
                });
              },
              child: FutureBuilder<List<Product>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> prodects = snapshot.data!;
                    if (_searchText.isNotEmpty) {
                      prodects = prodects.where((product) =>
                          product.name.toLowerCase().contains(_searchText.toLowerCase())
                      ).toList();
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ch_ls,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: prodects.length,
                      itemBuilder: (context, index) {
                          count =prodects.length;
                        return _buildProudectCard(prodects[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return  RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _futureProducts = Product.getProducts();
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
        onPressed: _addProduct,
      ),
    );
  }
}

