import 'package:flutter/material.dart';
import 'package:ammar/Login/a.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({ Key? key,this.child, this.decoration }) : super(key: key);
  final Widget? child;
  final Decoration? decoration;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal:20,vertical:5),
      width: size.width *0.9,
      decoration: decoration ,
      child: child,
    );
  }
}