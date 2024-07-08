import 'package:flutter/material.dart';
import 'package:ammar/Login/a.dart';

class PageTitleBar extends StatelessWidget {
  const PageTitleBar({ Key? key,required this.title }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 228.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:25.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: 25,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class PageTitleBarpro extends StatelessWidget {
  const PageTitleBarpro({ Key? key,required this.title }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 370.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 10,
        decoration:  const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(

            topLeft: Radius.circular(50),
           topRight: Radius.circular(50),
          ),

        ),
        child: Padding(
          padding: const EdgeInsets.only(top:5.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: 25,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}