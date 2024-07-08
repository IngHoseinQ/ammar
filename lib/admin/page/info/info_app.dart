import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../../Login/a.dart';
import 'Edit.dart';
import 'model_app.dart';

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late Future<List<Info>> _futureInfo;
  @override
  void initState() {
    super.initState();
    _futureInfo = Info.getInfo();
  }
  Future<void> _updateInfo(Info info) async {
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
    final result = await Get.to(() => EditInfo(info: info));
    if(result == T){
      Get.back();
    }else
    if (result != null) {
      await Info.updateInfo(result);
      Fluttertoast.showToast(
        msg: ' يرجا الانتظار تمت عملية التعديل بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back();
      setState(() {
        _futureInfo =  Info.getInfo();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('معلومات التطبيق'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
           _futureInfo = Info.getInfo();
          });
        },
        child: FutureBuilder<List<Info>>(
          future: _futureInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 0.5,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var info = snapshot.data![index];
                  return Card(
                    child: Center(
                      child: Column(
                        children: [

                          Container(
                              height: 200,
                              child: Image.memory(info.imageBytes)),
                         Text(
                              info.name,
                              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _updateInfo(info);
                            },
                          ),
                          SizedBox(height: 8.0),
                          RowWithCopyIcon(
                            icon: Icons.near_me,
                            text: info.name_app,
                          ),
                          SizedBox(height: 8.0),
                          RowWithCopyIcon(
                            icon: Icons.email,
                            text: info.email,
                          ),
                          SizedBox(height: 8.0),
                          RowWithCopyIcon(
                            icon: Icons.phone,
                            text: info.phone,
                          ),
                          SizedBox(height: 8.0),
                          RowWithCopyIcon(
                            icon: Icons.web,
                            text: info.web,
                          ),
                          SizedBox(height: 8.0),
                          RowWithCopyIcon(
                            icon: Icons.location_on,
                            text: info.adress,
                          ),
                          SizedBox(height: 8.0),
                          RowWithCopyIcon(
                            icon: Icons.description,
                            text: info.deck,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return  RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureInfo = Info.getInfo();
                  });
                },
                child: Center(child: Text('Error: خطا في جلب البيانات تحقق من الاتصال بالانترنت')
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
    );
  }
}

class RowWithCopyIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const RowWithCopyIcon({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          SizedBox(width: 28.0),
          Icon(icon),

          Expanded(
            child: Text(text, style: TextStyle(
              fontFamily: MyFont,

            ),textAlign: TextAlign.center),
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم النسخ إلى الحافظة'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}