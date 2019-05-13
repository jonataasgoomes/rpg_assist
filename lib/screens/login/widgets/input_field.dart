import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final Color color;
  final bool obscure;
  final TextInputType inputType;
  final Function validator;
  final TextEditingController controller;
  InputField({this.hint,this.obscure, this.color = Colors.white, this.inputType, this.validator, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: inputType,
        validator: validator,
        style: TextStyle(
          color: color,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: color,
            fontSize: 15,
          ),
          contentPadding: EdgeInsets.only(
            top: 30,
            right: 30,
            bottom: 10,
            left: 5
          )
        ),
      ),
    );
  }
}
