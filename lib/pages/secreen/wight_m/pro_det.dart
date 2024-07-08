import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Login/a.dart';
import '../../../Login/components/page_title_bar.dart';
import '../../../Login/components/upside.dart';
import '../../../admin/page/pro_control/model_control.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isDarkMode = false;
  late int id;
  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    });
  }

  void _sendMessage(String message) async {
    final url = 'whatsapp://send?text=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Theme(
        data: _themeData ?? ThemeData.light(),
        child: SafeArea(
          child: Scaffold(
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    UpsideProdect(
                      img:widget.product.imageBytes,
                    ),
                    PageTitleBarpro(title: widget.product.name),
                    Padding(
                      padding: const EdgeInsets.only(top: 420.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isDarkMode ? Colors.grey[900] : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  widget.product.description,
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: MyFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(height: 16.0),
                            ListTile(
                              leading: Icon(Icons.monetization_on_rounded),
                              title: Text(
                                'السعـر',
                                style: TextStyle(
                                  fontFamily: MyFont,
                                ),
                              ),
                              subtitle: Text(
                                '${widget.product.price}' +
                                    " " +
                                    '${widget.product.type_price}',
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.date_range),
                              title: Text(
                                'مضاف',
                                style: TextStyle(
                                  fontFamily: MyFont,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat.yMd()
                                    .add_jm()
                                    .format(widget.product.addDate!),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.category),
                              title: Text(
                                'القسم',
                                style: TextStyle(
                                  fontFamily: MyFont,
                                ),
                              ),
                              subtitle:
                              Text(widget.product.categoryName ?? '',style: TextStyle(
                                fontFamily: MyFont,
                              ),),
                            ),
                            SizedBox(height: 56.0),
                            ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                elevation: 10,
                                padding: EdgeInsets.all(15),
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(30)

                                ),),
                              onPressed: () {
                                String message =
                                    'أود طلب المنتج التالي: \n\n'
                                    'اسم المنتج: ${widget.product.name}'
                                    '\nالسعر: ${widget.product.price} ${widget.product.type_price}'
                                    '\nتاريخ الإضافة: ${DateFormat.yMd().add_jm().format(widget.product.addDate!)}'
                                    '\nالقسم: ${widget.product.categoryName ?? ''}'
                                    '\n\n';
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('تم نسخ الرسالة'),
                                      content:  Text('  تم نسخ الرسالة طلب المنتح  قم بالتواصل معنا وارسال رسالة الطلب عبر ارقامنا في التطبيق لتلبية طلبك'),
                                      actions: [

                                        ElevatedButton(
                                          style:ElevatedButton.styleFrom(
                                              elevation: 10,
padding: EdgeInsets.all(10),
                                              backgroundColor: kPrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.black26),
                                                  borderRadius: BorderRadius.circular(30)

                                              ),),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('موافق'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                Clipboard.setData(ClipboardData(text: message));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('  تم نسخ الرسالة طلب المنتح '),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.content_copy),
                                  SizedBox(width: 8),
                                  Text(
                                    'نسخ رسالة طلب المنتج',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: MyFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 100.0),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );

  }

}
