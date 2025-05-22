import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

typedef MyValidator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  final String? hint;
  final String? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final MyValidator? validator;
  final TextEditingController controller;
  final bool show;
  final ImageIcon? suffixIconShowed;
  final int? maxLength;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  const CustomTextFormField(
      {super.key,
      this.hint,
      this.suffixIcon,
      this.obscureText = false,
      this.validator,
      this.show = false,
      this.suffixIconShowed,
      this.prefixIcon,
      required this.controller,
      this.keyboardType,
      this.maxLength,
      this.maxLines,
      this.label});

  final int? animationIndex;

  const CustomTextFormField({
      super.key,
      this.hint,
      this.suffixIcon,
      this.obscureText = false,
      this.validator,
      this.show = false,
      this.suffixIconShowed,
      this.prefixIcon,
      required this.controller,
      this.keyboardType,
      this.maxLength,
      this.maxLines,
      this.label,
      this.animationIndex,
      this.onSubmitted,
      this.textInputAction,
      this.autofillHints});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      maxLines: maxLines ?? 1,
      style: TextStyles.fontCircularSpotify14BlackMedium,
      autocorrect: true,
      obscureText: obscureText,
      onFieldSubmitted: onSubmitted,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
        labelText: label,
        prefixIcon: prefixIcon,
      ),
      buildCounter: maxLength != null
          ? (context,
              {required currentLength,
              required isFocused,
              required maxLength}) {
              return Text(
                '$currentLength/$maxLength',
                style: TextStyle(
                    fontSize: 12,
                    color: currentLength == maxLength
                        ? AppColor.redColor
                        : AppColor.blueColor),
              );
            }
          : null,
    )
    .animate()
    .slideX(begin: -1, end: 0, duration: const Duration(milliseconds: 500), delay: Duration(milliseconds: (animationIndex ?? 0) * 200))
    .fadeIn(duration: const Duration(milliseconds: 500));
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      maxLines: maxLines ?? 1,
      style: TextStyles.fontCircularSpotify14BlackMedium,
      autocorrect: true,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
        labelText: label,
        prefixIcon: prefixIcon,
      ),
      buildCounter: maxLength != null
          ? (context,
              {required currentLength,
              required isFocused,
              required maxLength}) {
              return Text(
                '$currentLength/$maxLength',
                style: TextStyle(
                    fontSize: 12,
                    color: currentLength == maxLength
                        ? AppColor.redColor
                        : AppColor.blueColor),
              );
            }
          : null,
    );
  }
}
