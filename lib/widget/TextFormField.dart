import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  String? lableText;
  final bool validation;
  final TextEditingController controller;
  final ValueChanged? onChange;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatters;
  final int? maxLines;

  final bool? enabled;

  CustomTextField(
      {super.key,
      required this.validation,
      required this.controller,
      this.lableText,
      this.onChange,
      this.textInputType,
      this.textInputFormatters,
      this.maxLines,
      this.enabled});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      style: const TextStyle(),
      autofocus: false,
      obscureText: false,
      onChanged: widget.onChange,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines ?? 1,
      inputFormatters: widget.textInputFormatters,
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: widget.lableText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        filled: true,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xffBDBDBD),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffBDBDBD), width: 2),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffBDBDBD), width: 2),
        ),
        errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
      ),
      controller: widget.controller,
      validator: (value) {
        if (widget.lableText == "Password") {
          if (value == null || value.isEmpty) {
            return 'Field ${widget.lableText} must be provided ';
          }
        }
        if (value == null || value.isEmpty) {
          return 'Field ${widget.lableText} must be provided ';
        } else if (!value.contains('@') && widget.validation == true) {
          return 'your email is not correct ';
        }
        return null;
      },
    );
  }
}
