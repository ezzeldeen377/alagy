import 'package:alagy/core/utils/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isEnable;
  final TextInputType? keyboardType;
  final MyValidator? validator;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final Function? onTap;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isEnable = true,
    this.keyboardType,
    this.validator ,
    this.onChanged, this.inputFormatters, this.readOnly, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        enabled: isEnable,readOnly: readOnly ?? false,onTap: (){onTap?.call();},
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal.shade700),
          contentPadding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,inputFormatters: inputFormatters,
        
      ),
    );
  }
}