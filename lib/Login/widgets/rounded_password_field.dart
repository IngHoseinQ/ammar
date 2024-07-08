import 'package:flutter/material.dart';
import 'package:ammar/Login/a.dart';
import 'package:ammar/Login/widgets/widgets.dart';

class RoundedPasswordField extends StatefulWidget {
  const RoundedPasswordField({ Key? key, this.hintText, this.controller, required this.validator }) : super(key: key);
  final String? hintText;
  final String? Function(dynamic value) validator;
  final TextEditingController? controller;

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(

       controller: widget.controller ,
        obscureText: _obscureText,
        cursorColor: kPrimaryColor,
         decoration: InputDecoration(
             prefixIcon: Icon(
              Icons.key,
              color: kPrimaryColor,
            ),
             hintText: widget.hintText,

            hintStyle: TextStyle( fontFamily: 'Cairo',),
             suffixIcon: IconButton(
               icon: Icon(
                 _obscureText ? Icons.visibility : Icons.visibility_off,
                 color:Colors.cyan,
               ),
               onPressed: () {
                 setState(() {
                   _obscureText = !_obscureText;
                 });
               },
             ),
    border: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(29),
    borderSide: BorderSide(color: kPrimaryColor,width: 5.0),
    ),
         ),
        validator: widget.validator,
      ),

    );
  }
}