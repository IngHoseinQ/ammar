import 'package:ammar/Login/a.dart';
import 'package:ammar/admin/page/cate_control/model_control.dart';
import 'package:ammar/pages/secreen/wight_m/pro_by_cate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../admin/page/offs_control/model_control.dart';
import '../../../admin/page/pro_control/model_control.dart';
import 'all_cate.dart';
import 'all_pro.dart';
import 'pro_det.dart';

class CeremonyHomePage extends StatefulWidget {
  @override
  State<CeremonyHomePage> createState() => _CeremonyHomePageState();
}

class _CeremonyHomePageState extends State<CeremonyHomePage> {
  late Future<List<Offs>> _futureOffs;
  late Future<List<Category>> _futureCategories;
  late Future<List<Product>> _futureProducts;
  bool _isDarkMode = false;
  ThemeData? _themeData;
  @override
  void initState() {
    super.initState();
    _loadTheme();
    _futureOffs = Offs.getOffs();
    _futureProducts =Product.getProducts();
    _futureCategories =Category.getCategories();
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
    return  Theme(
      data: _themeData ?? ThemeData.light(),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'الـعــروض',
                      style: TextStyle(
                        fontFamily: MyFont,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 8),Container(
        height: 200,
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
                List<Offs> offrest = snapshot.data!;
                return PageIndicatorContainer(
                  child: PageView.builder(
                    itemCount: offrest.length,
                    itemBuilder: (context, index) {
                      return _buildOffsCard(offrest[index]);
                    },
                  ),
                  length: offrest.length,
                  align: IndicatorAlign.bottom,
                  indicatorSpace: 8.0,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: خطا في جلب البيانات تحقق من الاتصال بالانترنت'));
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
              SizedBox(height: 16),
          //    SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Text(
                    'الاقــسـام',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: MyFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(),
                  SizedBox(),
                  TextButton(
                    onPressed: () {
                   Get.to(()=>viewallcate());
                    },
                    child:  Row(
                      children: [

                        Text(
                          'مـشاهدة الكـل ',
                          style: TextStyle(
                            color:Colors.blue,
                            fontFamily: MyFont,
                          ),
                        ),
                        Icon(Icons.arrow_circle_left_outlined),
                      ],
                    ),
                  ),
                ],
              ),
        SizedBox(height: 8),
        RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _futureCategories = Category.getCategories();
            });
          },
          child: Container(
            height: 95,
            child: FutureBuilder<List<Category>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Category> categories = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      Category category = categories[index];
                      return Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: _buildCategoryCard(category,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _futureCategories = Category.getCategories();
                        });
                      },
                      child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _futureOffs = Offs.getOffs();
                            });
                          },
                          child: Center(child: Text('Error: خطا في جلب البيانات تحقق من الاتصال بالانترنت'))));
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Text(
                    'المــنـتجـات',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: MyFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(),
                  SizedBox(),
                  TextButton(
                    onPressed: () {
Get.to(()=>viewallpro());
                    },
                    child:  Row(
                      children: [

                        Text(
                          'مـشاهدة الكـل ',
                          style: TextStyle(
                            fontFamily: MyFont,
                            color:Colors.blue,

                          ),
                        ),
                        Icon(Icons.arrow_circle_left_outlined),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureProducts = Product.getProducts();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: FutureBuilder<List<Product>>(
                    future: _futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Product> products = snapshot.data!;
                        return MasonryGridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            Product product = products[index];
                            return _buildProductCard(product
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                _futureProducts = Product.getProducts();
                              });
                            },
                            child: Center(child: Text('Error: خطا في جلب البيانات تحقق من الاتصال بالانترنت')));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),

            ],
          ),
      ),
    );
  }
}

Widget _buildCategoryCard(Category category) {
 // Future<void> go(int id)async{
//await Get.to(get_pro_by_cate(cate:category));
  //}
  //var v =Product.getProductsByCategory(category.id);
  return GestureDetector(
    onTap: () async {
      await Get.to(() => get_pro_by_cate(cate:category));
    },
    child: Container(
      width: 150,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(

          side: BorderSide(color:kPrimaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Hero(

          tag: 'image_${category.id}',
          child: Stack(
fit: StackFit.expand,


            children: [
              ClipRRect(

                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  category.imageBytes,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.only(left:15 ,right:15  ),
                      child: Text(
                        category.name,

                        style: TextStyle(
                          fontFamily: MyFont,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Color.fromRGBO(24, 24, 24, 80),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget _buildProductCard(Product product) {
  return GestureDetector(
    onTap: () {
      Get.to(()=>ProductDetailsPage(product: product));
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color:kPrimaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Hero(
        tag: product.id,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.memory(
                product.imageBytes,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFont,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    style: TextStyle(
                      fontFamily: MyFont,
                    ),

                    product.price.toString() + ' ' + product.type_price,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}




Widget _buildOffsCard(Offs offs) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.memory(
          offs.imageBytes,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
