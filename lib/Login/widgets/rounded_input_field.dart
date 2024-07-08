import 'package:flutter/material.dart';
import 'package:ammar/Login/a.dart';
import 'package:ammar/Login/widgets/widgets.dart';

class RoundedInputField extends StatefulWidget {
  const RoundedInputField({Key? key, this.hintText, this.icon = Icons.person, this.controller, required this.validator})
      : super(key: key);
  final String? hintText;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(dynamic value) validator;

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(

      child: TextFormField(

        controller: widget.controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          hintStyle:  TextStyle( fontFamily: 'Cairo',),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(29),
            borderSide: BorderSide(color: kPrimaryColor2),
          ),
        ),
        validator: widget.validator,
      ),

    );
  }
}
