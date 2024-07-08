import 'package:ammar/admin/page/cate_control/model_control.dart';
import 'package:ammar/admin/page/pro_control/model_control.dart';
import 'package:ammar/pages/secreen/wight_m/pro_det.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Login/a.dart';
class get_pro_by_cate extends StatefulWidget {
final Category cate;

   get_pro_by_cate({super.key, required this.cate});

  @override
  State<get_pro_by_cate> createState() => _get_pro_by_cateState();
}

class _get_pro_by_cateState extends State<get_pro_by_cate> {
  late Future<List<Product>> _futurePro_cate;
  String _searchText = '';
  bool _isDarkMode = false;
  late int id;
  ThemeData? _themeData;
  late bool _isOne = false;
  int ch_ls=2;
  @override
  void initState() {
    super.initState();
    id =widget.cate.id;
    _loadTheme();
    _futurePro_cate = Product.getProductsByCategory(id);
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

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(data: _themeData ?? ThemeData.light(),
        child: Scaffold(
          body: CustomScrollView(

            slivers: [

              SliverAppBar(
                backgroundColor: kPrimaryColor,
                elevation: 3,
                leading: Container(
                  padding: EdgeInsets.only(left:2 ,right:2,top: 0,bottom: 0 ),
                  child:   IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  margin: EdgeInsets.only(top: 3,bottom: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color.fromRGBO(24, 24, 24, 80),
                  ),
                ),
                actions: [
                  Container(
                    padding: EdgeInsets.only(left:2 ,right:2,top: 0,bottom: 0 ),
                    child:   IconButton(
                      icon: _isOne ? Icon(Icons.grid_view_sharp ,color: Colors.green,) : Icon(
                          Icons.menu,color: Colors.green),
                      onPressed: (){
                        ch();
                      },
                    ),
                    margin: EdgeInsets.only(top: 3,bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color.fromRGBO(24, 24, 24, 80),
                    ),
                  ),

                ],
                pinned: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                expandedHeight: 300.0,
                flexibleSpace:  FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(9),
                    collapseMode: CollapseMode.pin,


                    background: Hero(
                      tag: 'image_${widget.cate.id}',
                      child: (() {
                            return Image.memory(widget.cate.imageBytes, fit: BoxFit.cover);
                          }

                      )(),
                    ),
                    title: Container(
                      padding: EdgeInsets.only(left:20 ,right:20  ),
                      child: Text(
                        widget.cate.name.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                          fontFamily: MyFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Color.fromRGBO(24, 24, 24, 80),
                      ),
                    ),
                    centerTitle: true,
                  ),

              ),
              SliverFillRemaining(

                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Text(
                        widget.cate.description.toString(),
                        style: TextStyle(
                          fontSize: 23.0,
                          fontFamily: MyFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(

                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
                          style: TextStyle(   fontFamily: MyFont),
                          decoration: InputDecoration(

                            hintText: 'ابحــث هنا...',
                            hintStyle: TextStyle(   fontFamily: MyFont),
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
                              _futurePro_cate = Product.getProductsByCategory(id);
                            });
                          },
                          child: FutureBuilder<List<Product>>(
                            future: _futurePro_cate,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Product> products = snapshot.data!;
                                if (_searchText.isNotEmpty) {
                                  products = products.where((product) =>
                                      product.name.toLowerCase().contains(_searchText.toLowerCase())
                                  ).toList();
                                }
                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: ch_ls,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return _buildProudectCard(products[index]);
                                  },
                                );
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                                return  RefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {
                                        _futurePro_cate = Product.getProductsByCategory(id);
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
                ),
              ),
            ],
          ),
        ),


    );

  }
  Widget _buildProudectCard(Product product) {

    return GestureDetector(
      onTap: () {
        Get.to(()=>ProductDetailsPage(product: product));
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
                  fontFamily: MyFont,
                  fontWeight: FontWeight.bold,
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
                  fontFamily: MyFont,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
