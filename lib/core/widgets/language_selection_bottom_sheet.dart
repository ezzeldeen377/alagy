import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';

class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguageSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDark;
    final currentLocale = context.read<AppSettingsCubit>().state.locale;
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          
          // Title
          Text(
            context.l10n.selectLanguage,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8.h),
          
          // Subtitle
          Text(
            context.l10n.chooseLanguage,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColor.greyColor,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 24.h),
          
          // Language options
          _buildLanguageOption(
            context: context,
            languageCode: 'en',
            languageName: context.l10n.english,
            languageNameNative: 'English',
            isSelected: currentLocale.languageCode == 'en',
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 12.h),
          
          _buildLanguageOption(
            context: context,
            languageCode: 'ar',
            languageName: context.l10n.arabic,
            languageNameNative: 'العربية',
            isSelected: currentLocale.languageCode == 'ar',
            isDarkMode: isDarkMode,
          ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String languageCode,
    required String languageName,
    required String languageNameNative,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<AppSettingsCubit>().setLocale(Locale(languageCode));
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColor.primaryColor.withOpacity(0.1)
              : (isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA)),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected 
                ? AppColor.primaryColor
                : (isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE5E7EB)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Language flag or icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.language,
                color: AppColor.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            
            // Language names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    languageNameNative,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.greyColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColor.primaryColor,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}