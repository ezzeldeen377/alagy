import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/font_weight_helper.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColor.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: AppColor.primaryColor,
        onPrimary: AppColor.whiteColor,
        primaryContainer: AppColor.secondryColor,
        secondary: AppColor.secondryColor,
        onSecondary: AppColor.whiteColor,
        secondaryContainer: AppColor.primaryColor,
        surface: AppColor.whiteColor,
        onSurface: AppColor.blackColor,
      ),
      scaffoldBackgroundColor: AppColor.whiteColor,
      applyElevationOverlayColor: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColor.whiteColor,
        ),
      ),
      tabBarTheme: TabBarThemeData(
         labelColor: AppColor.primaryColor,
                unselectedLabelColor: Colors.grey[500],
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
               dividerColor: Colors.transparent,indicatorColor:  AppColor.primaryColor,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColor.whiteColor,
        scrimColor: AppColor.fifthColor,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColor.whiteColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColor.primaryColor),
          
      iconTheme: const IconThemeData(color: AppColor.blackColor),
      snackBarTheme:  SnackBarThemeData(
          backgroundColor: AppColor.primaryColor,
          contentTextStyle: TextStyles.fontCircularSpotify14BlackMedium.copyWith(color: AppColor.whiteColor) ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        hintStyle: TextStyles.fontCircularSpotify14BlackMedium
            .copyWith(fontWeight: FontWeightHelper.regular),
        labelStyle: TextStyles.fontCircularSpotify14BlackMedium,
        filled: true,
        fillColor: AppColor.whiteColor,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.redColor.withOpacity(.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.redColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.primaryColor.withOpacity(.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.greyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.primaryColor.withOpacity(.8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 57,
              fontWeight: FontWeight.normal,
              color: AppColor.primaryColor),
          displayMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 45,
              fontWeight: FontWeight.normal,
              color: AppColor.primaryColor),
          displaySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 36,
              fontWeight: FontWeight.normal,
              color: AppColor.primaryColor),
          headlineLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor),
          headlineMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor),
          headlineSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor),
          titleLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColor.blackColor),
          titleMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.blackColor),
          titleSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.blackColor),
          bodyLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColor.blackColor),
          bodyMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.blackColor),
          bodySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColor.blackColor),
          labelLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor),
          labelMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor),
          labelSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColor.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColor.primaryColor,
        onPrimary: AppColor.blackColor,
        primaryContainer: AppColor.primaryColor,
        secondary: AppColor.secondryColor,
        onSecondary: AppColor.blackColor,
        secondaryContainer: AppColor.primaryColor,
        surface: AppColor.blackColor,
        onSurface: AppColor.whiteColor
      ),
        tabBarTheme: const TabBarThemeData(
         labelColor: AppColor.primaryColor,
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
               dividerColor:  Colors.transparent,indicatorColor:  AppColor.primaryColor,
      ),
      scaffoldBackgroundColor: AppColor.blackColor,
      applyElevationOverlayColor: true,
       appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColor.whiteColor,
        ),
      ),
      
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColor.blackColor,
        scrimColor: AppColor.blackColor.withOpacity(0.5),
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColor.blackColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColor.primaryColor),
      snackBarTheme:  SnackBarThemeData(
          backgroundColor: AppColor.primaryColor,
          contentTextStyle: TextStyles.fontCircularSpotify14BlackMedium.copyWith(color: AppColor.whiteColor) ),
      iconTheme: const IconThemeData(color: AppColor.whiteColor),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        hintStyle: TextStyles.fontCircularSpotify14WhiteMedium
            .copyWith(fontWeight: FontWeightHelper.regular),
        labelStyle: TextStyles.fontCircularSpotify14WhiteMedium,
        filled: true,
        fillColor: AppColor.blackColor,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.redColor.withOpacity(.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.redColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.fourthColor.withOpacity(.8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.greyColor.withOpacity(.2),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.fourthColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 57,
              fontWeight: FontWeight.normal,
              color: AppColor.whiteColor),
          displayMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 45,
              fontWeight: FontWeight.normal,
              color: AppColor.whiteColor),
          displaySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 36,
              fontWeight: FontWeight.normal,
              color: AppColor.whiteColor),
          headlineLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor),
          headlineMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor),
          headlineSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor),
          titleLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor),
          titleMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor),
          titleSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor),
          bodyLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColor.whiteColor),
          bodyMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.whiteColor),
          bodySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColor.whiteColor),
          labelLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor),
          labelMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor),
          labelSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor)),
    );
  }
}
