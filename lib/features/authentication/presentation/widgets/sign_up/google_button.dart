import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class GoogleButton extends StatelessWidget {
  final void Function()? onTapButton;
  const GoogleButton({super.key, required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapButton,
      child: Container(
        height: 45.h,
        width: 305.w,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/google.svg'),
            SizedBox(width: 3.w),
            Text("Connect with Google",
                style: TextStyles.font14RobotoDarkGreenColorMedium),
          ],
        ),
      ),
    );
  }
}
