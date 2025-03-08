import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


typedef MyValidator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final MyValidator? validator;
  final TextEditingController controller;
  final bool show;
  final ImageIcon? suffixIconShowed;
  final int? maxLength;
  final TextInputType? keyboardType;
  const CustomTextFormField({
      super.key,
      required this.hint,
      this.suffixIcon,
      this.obscureText = false,
      this.validator,
      this.show = false,
      this.suffixIconShowed,
      this.prefixIcon,
      required this.controller,
      this.keyboardType,
      this.maxLength});

  @override
 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      maxLength: maxLength,
      validator: validator,
      maxLines: null,
      style: TextStyles.fontInter14BlackMedium,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyles.fontRoboto12GreyRegular,
        filled: true,
        fillColor: AppColor.lightWhiteColor,
        prefixIcon: prefixIcon,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.redColor.withOpacity(.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.redColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.lgGreyColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.grayColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
      ),
      buildCounter: maxLength != null?(context, {required currentLength, required isFocused, required maxLength}) {
                              return Text('$currentLength/$maxLength',style: TextStyle(
                                fontSize: 12,
                                color: currentLength==maxLength?AppColor.redColor:AppColor.blueColor
                              ),);}:null,
    );
  }
}
