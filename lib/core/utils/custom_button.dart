import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Widget buttonContent;
  final void Function()? onTapButton;
  final int? animationIndex;

  const CustomButton(
      {super.key,
      required this.buttonContent,
      required this.onTapButton,
      this.animationIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTapButton,
        child: Container(
            height: 60.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: AppColor.appGradientBackground,
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: buttonContent,
            )));
  }
}
