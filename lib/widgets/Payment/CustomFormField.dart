import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType inputType;
  final TextInputFormatter formatter;
  final String? Function(String?)? validator;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    required this.inputType,
    required this.formatter,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextFormField(
      controller: controller,
      cursorColor: Colors.black26,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.02),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      keyboardType: inputType,
      inputFormatters: [formatter],
      validator: validator,
    );
  }
}