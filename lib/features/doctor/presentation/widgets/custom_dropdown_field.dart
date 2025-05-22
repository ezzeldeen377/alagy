import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final IconData icon;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.label,
    required this.icon,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        menuMaxHeight: 500.h,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColor.tealNew),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(vertical: 16, ),
        ),
        dropdownColor: Theme.of(context).cardColor,
        iconEnabledColor: AppColor.tealNew,
        iconDisabledColor: Colors.grey,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}