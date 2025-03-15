import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric( horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.mintGreen.withOpacity(.2),
        border: Border.all(
          color: AppColor.textFieldBorder,
          width: .5,
        ),
      ),
      child: child,
    );
  }
}
