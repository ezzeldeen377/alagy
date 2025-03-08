import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHader extends StatelessWidget {
  final String boldText;
  final String text;
  const CustomHader({super.key, required this.boldText, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          boldText,
          style: TextStyles.fontInter20WhiteSemiBold.copyWith(
            color: Colors.black,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          text,
          style: TextStyles.fontInter14BlackMedium.copyWith(
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
