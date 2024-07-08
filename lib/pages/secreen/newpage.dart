import 'package:ammar/pages/secreen/wight_m/pro_det.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Login/a.dart';
import '../../admin/page/pro_control/model_control.dart';

class New extends StatefulWidget {
  const New({Key? key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  late Future<List<Product>> _future_new;
  bool _isDarkMode = false;
  ThemeData? _themeData;
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _future_new = Product.getNewProducts().then((products) {
      return products.where((product) => product.addDate != null).toList();
    }).catchError((error) {
      print('Error fetching new products: $error');
      return <Product>[];
    });
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    });
  }
  void _filterProductsByTimeRange(DateTime startTime) {
    Product.getNewProducts().then((products) {
      setState(() {
        _filteredProducts = products.where((product) => product.addDate?.isAfter(startTime) ?? false).toList();
      });
    }).catchError((error) {
      print('Error fetching new products: $error');
      setState(() {
        _filteredProducts = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData ?? ThemeData.light(),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 90, right: 170, top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'الجديد',
                    style: TextStyle(
                      fontFamily: MyFont,
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      DateTime? selectedTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now(),
                      );
                      if (selectedTime != null) {
                        _filterProductsByTimeRange(selectedTime);
                      }
                    },
                    icon: Icon(Icons.filter_list_alt,color: Colors.cyan,),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _future_new = Product.getNewProducts().then((products) {
                        return products.where((product) => product.addDate != null).toList();
                      }).catchError((error) {
                        print('Error fetching new products: $error');
                        return <Product>[];
                      });
                    });
                  },
                  child: FutureBuilder<List<Product>>(
                    future: _filteredProducts.isNotEmpty ? Future.value(_filteredProducts) : _future_new,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Product> products = snapshot.data!;
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return _buildProudectCard(products[index]);
                          },
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _future_new = Product.getNewProducts().then((products) {
                                return products.where((product) => product.addDate != null).toList();
                              }).catchError((error) {
                                print('Error fetching new products: $error');
                                return <Product>[];
                              });
                            });
                          },
                          child: Center(
                            child: Text('حدث خطأ أثناء تحميل المنتجات.'),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProudectCard(Product product) {
    bool isNew = false;
    final now = DateTime.now();
    final difference = now.difference(product.addDate!).inDays;
    if (difference <= 3) {
      isNew = true;
    }

    String dayLabel = " يوم ";
    if (product.addDate != null) {
      final daysSinceAdded = now.difference(product.addDate!).inDays;
      if (daysSinceAdded > 1) {
        dayLabel = "أيام";
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(()=>ProductDetailsPage(product: product));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),

                    child: Image.memory(
                      product.imageBytes,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'الاسم : ' + product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: MyFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'السعر: ' +
                        product.price.toString() +
                        ' ' +
                        product.type_price,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: MyFont,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(

                    product.categoryName!,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: MyFont,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 5),
                      Text(
                        '$dayLabel $difference',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: MyFont,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          if (isNew)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'جديد',
                  style: TextStyle(
                    fontFamily: MyFont,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}