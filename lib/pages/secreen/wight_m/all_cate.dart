import 'package:ammar/pages/secreen/wight_m/pro_by_cate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../Login/a.dart';
import '../../../admin/page/cate_control/model_control.dart';
class viewallcate extends StatefulWidget {
  const viewallcate({super.key});

  @override
  State<viewallcate> createState() => _viewallcateState();
}

class _viewallcateState extends State<viewallcate> {
  late Future<List<Category>> _futureCategories;
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
    _futureCategories = Category.getCategories();
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
  Widget _buildCategoryCard(Category category) {
    // Future<void> go(int id)async{
//await Get.to(get_pro_by_cate(cate:category));
    //}
    //var v =Product.getProductsByCategory(category.id);
    return GestureDetector(
      onTap: () async {
        await Get.to(() => get_pro_by_cate(cate:category));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Hero(
          tag: 'image_${category.id}',
          child: Stack(
            clipBehavior: Clip.antiAlias,
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  category.imageBytes,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
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

            ],

          ),
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
                child: Text('  االاقــسـام - ( '+count.toString()+' )',style:  TextStyle(
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
                    _futureCategories = Category.getCategories();
                  });
                },
                child: FutureBuilder<List<Category>>(
                  future: _futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Category> categories = snapshot.data!;
                      if (_searchText.isNotEmpty) {
                        categories = categories.where((category) =>
                            category.name.toLowerCase().contains(_searchText.toLowerCase())
                        ).toList();
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ch_ls,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          count =categories.length;
                          return _buildCategoryCard(categories[index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return  RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _futureCategories = Category.getCategories();
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



