import 'package:ammar/Login/a.dart';
import 'package:ammar/pages/secreen/wight_m/pro_det.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../admin/page/pro_control/model_control.dart';
class viewallpro extends StatefulWidget {
  const viewallpro({super.key});

  @override
  State<viewallpro> createState() => _viewallproState();
}

class _viewallproState extends State<viewallpro> {
  late Future<List<Product>> _futureProducts;
  String _searchText = '';
  late int count=0;
  late bool off=false;
  late bool _isOne = false;
  bool _isDarkMode = false;
  ThemeData? _themeData;
  int ch_ls=2;
  @override
  void initState() {
    super.initState();
    off;
    _loadTheme();
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
                  fontFamily: MyFont,
                  fontSize: 18,
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
                  fontSize: 15,
                  fontFamily: MyFont,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
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
    return Theme(
      data: _themeData ?? ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Container(
              padding: EdgeInsets.only(left:2 ,right:2,top: 0,bottom: 0 ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Color.fromRGBO(24, 24, 24, 80),

              ),
              child: Text(' المنـتـجـات - ( '+count.toString()+' )',style:  TextStyle(
                fontFamily: MyFont,
              ),) ),
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
]
      ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style:  TextStyle(
                  fontFamily: MyFont,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                autofocus: off,
                decoration: InputDecoration(
                  hintText: 'ابحــث هنا...',
                  prefixIcon: Icon(Icons.search),
hintStyle: TextStyle(
  fontFamily: MyFont,
),
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
                          childAspectRatio: 0.9,
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
      ),
    );
  }
}


