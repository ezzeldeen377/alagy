import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: AppColor.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child:Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20.sp),
    ),
    SizedBox(width: 4.w),
    Text(
      label,
      style: context.theme.textTheme.bodyMedium,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  ],
)

      ),
    );
  }
}
