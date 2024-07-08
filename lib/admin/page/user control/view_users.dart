import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'model.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late Future<List<Users>> _futureUsers;
  String _searchText = '';
  late bool _isOne = false;
  late bool off=false;
  int ch_ls=2;
  late int count=0;

  @override
  void initState() {
    super.initState();
    off;
    _futureUsers = Users.getUsers();
  }

  /// Toggles between list and grid view.
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




  /// Deletes the selected user.
  Future<void> _deleteUser(int userId) async {
    await Users.deleteUser(userId);
    Fluttertoast.showToast(
      msg:'تم الحذف بنجاح',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      _futureUsers = Users.getUsers();
    });
  }

  /// Builds a card for each user with their details and options to edit or delete.
  Widget _buildUserCard(Users user) {
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
                  SizedBox(height: 10.0),
                  Text(
                    'هل أنت متأكد أنك تريد حذف  هذا المستخدم ؟',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back(result: false);
                        },
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back(result: true);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text(
                          'حـذف',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      );
      if (resltResbons == true) {
        await _deleteUser(user.id)
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

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.blue,width:0.8 )
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
        ),
        child: ListTile(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(
                'assets/images/img_4.png',
                ),
              ),
            ),

          title: Text(
            ' الاسم : ${user.name}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Text(
                ' الايميل : ${user.email}',
              ),
              SizedBox(height: 5.0),
              Text(
                '  رقـم الهاتف : ${user.phone}',
              ),
              SizedBox(height: 5.0),

            ],
          ),

          trailing: IconButton(
            icon: Icon(Icons.delete,color: Colors.red,size: 30,),
            onPressed: () {
              Del();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('  ادرة المسـتـخـدمبن - ( '+count.toString()+' )'),
        actions: <Widget>[
          Icon(Icons.account_circle),
         // IconButton(icon: ch_ls == 2 ? Icon(Icons.view_module) : Icon(Icons.view_list), onPressed: ch,),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: off,
                decoration: InputDecoration(
                  hintText: 'ابحــث هنا...',
                  prefixIcon: Icon(Icons.search),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureUsers = Users.getUsers();
                  });
                },
                child: FutureBuilder<List<Users>>(
                  future: _futureUsers,
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return  Center(child: Text('Error: خطا في جلب البيانات تحقق من الاتصال بالانترنت'));
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final users = snapshot.data!
                          .where((user) =>
                      user.name
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()) ||
                          user.email
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()) ||
                          user.phone
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))
                          .toList();
                      return ch_ls == 2
                          ? ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          count =users.length;
                          return _buildUserCard(users[index]);

                        },
                      )
                          : GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return _buildUserCard(users[index]);
                        },
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