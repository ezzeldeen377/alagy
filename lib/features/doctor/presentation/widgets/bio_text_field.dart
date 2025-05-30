import 'package:flutter/material.dart';

class BioTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const BioTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
      ),
      maxLines: 5,
   
    );
  }
}