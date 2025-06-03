import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 44.w,
        right: 44.w,
        bottom: 30.h,
      ),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: context.isDark ? Colors.blueGrey.withOpacity(0.1) : Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 0, Icons.home_rounded, context.l10n.home),
            _buildNavItem(context, 1, Icons.bookmark_rounded, context.l10n.bookmarks),
            _buildNavItem(context, 2, Icons.search_rounded, context.l10n.search),
            _buildNavItem(context, 3, Icons.notifications_rounded, context.l10n.notifications),
            _buildNavItem(context, 4, Icons.settings_rounded, context.l10n.settings),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String title) {
    final bool isSelected = index == currentIndex;
    
    return InkWell(
      onTap: () {
        onTap(index);
      },
      customBorder: const CircleBorder(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 6.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: isSelected 
                  ? AppColor.primaryColor
                  : AppColor.greyColor 
            ),
            if (isSelected) ...[
              SizedBox(height: 2.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}