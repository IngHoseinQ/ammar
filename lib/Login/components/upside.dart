import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ammar/Login/a.dart';

class Upside extends StatelessWidget {
  const Upside({Key? key, required this.imgUrl}) : super(key: key);
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height / 2,
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              imgUrl,
              alignment: Alignment.topCenter,
              scale: 8,
            ),
          ),
        ),
        iconBackButton(context),
        Positioned(
          left: 0,
          top: 175,
          child: Image.asset(
            "assets/images/img_2.png",
            scale: 3,
          ),
        ),
        Positioned(
          right: 0,
          top: 60,
          child: Image.asset(
            "assets/images/img_1.png",
            scale: 3,
          ),
        ),
      ],
    );
  }
}

iconBackButton(BuildContext context) {
  return Container(
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
  );
}
class UpsideProdect extends StatelessWidget {
  const UpsideProdect({Key? key, required this.img}) : super(key: key);
  final Uint8List img;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.black26)

            )
          ),
          width: size.width ,
          height: size.height,
            child: Image.memory(
              img,fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              scale: 8,
            ),

        ),
        iconBackButton(context),
      ],
    );
  }
}


