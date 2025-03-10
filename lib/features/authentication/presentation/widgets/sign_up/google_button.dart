import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        width: double.infinity,
        decoration: BoxDecoration(
          color:context.isDark? AppColor.ofWhiteColor:AppColor.mintGreen.withOpacity(.3),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/google.svg'),
            SizedBox(width: 5.w),
            Text(context.l10n.connectWithGoogle,
                style: context.theme.textTheme.bodyMedium?.copyWith(color: AppColor.accentBlackColor2)),
          ],
        ),
      ),
    );
  }
}


