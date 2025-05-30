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
      primaryColor: AppColor.tealNew,
      colorScheme: const ColorScheme.light(
        primary: AppColor.tealNew,
        onPrimary: AppColor.white,
        primaryContainer: AppColor.mintGreen,
        secondary: AppColor.darkTeal,
        onSecondary: AppColor.white,
        secondaryContainer: AppColor.teal,
        surface: AppColor.white,
        onSurface: AppColor.darkGray
      ),
      scaffoldBackgroundColor: AppColor.white,
      applyElevationOverlayColor: true,
      tabBarTheme: TabBarThemeData(
         labelColor: AppColor.tealNew,
                unselectedLabelColor: Colors.grey[500],
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
               dividerColor: Colors.transparent,indicatorColor:  AppColor.tealNew,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColor.white,
        scrimColor: AppColor.beige,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColor.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColor.white),
      iconTheme: const IconThemeData(color: AppColor.darkTeal),
      snackBarTheme:  SnackBarThemeData(
          backgroundColor: AppColor.darkTeal,
          contentTextStyle: TextStyles.fontCircularSpotify14BlackMedium.copyWith(color: AppColor.whiteColor) ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        hintStyle: TextStyles.fontCircularSpotify14BlackMedium
            .copyWith(fontWeight: FontWeightHelper.regular),
        labelStyle: TextStyles.fontCircularSpotify14BlackMedium,
        filled: true,
        fillColor: AppColor.white,
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
              color: AppColor.darkTeal.withOpacity(.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.lgGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.darkTeal.withOpacity(.8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 57,
              fontWeight: FontWeight.normal,
              color: AppColor.tealNew),
          displayMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 45,
              fontWeight: FontWeight.normal,
              color: AppColor.tealNew),
          displaySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 36,
              fontWeight: FontWeight.normal,
              color: AppColor.tealNew),
          headlineLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColor.tealNew),
          headlineMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.tealNew),
          headlineSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.tealNew),
          titleLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColor.darkGray),
          titleMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.darkGray),
          titleSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.darkGray),
          bodyLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColor.darkGray),
          bodyMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.darkGray),
          bodySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColor.darkGray),
          labelLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.darkGray),
          labelMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.darkGray),
          labelSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColor.darkGray)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColor.darkTeal,
      colorScheme: const ColorScheme.dark(
        primary: AppColor.darkTeal,
        onPrimary: AppColor.offWhite,
        primaryContainer: AppColor.teal,
        secondary: AppColor.mintGreen,
        onSecondary: AppColor.darkGray,
        secondaryContainer: AppColor.tealNew,
        surface: AppColor.darkGray,
        onSurface: AppColor.offWhite
      ),
        tabBarTheme: const TabBarThemeData(
         labelColor: AppColor.tealNew,
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
               dividerColor:  Colors.transparent,indicatorColor:  AppColor.tealNew,
      ),
      scaffoldBackgroundColor: AppColor.darkGray,
      applyElevationOverlayColor: true,
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColor.darkGray,
        scrimColor: AppColor.blackColor.withOpacity(0.5),
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColor.darkGray,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColor.white),
      snackBarTheme:  SnackBarThemeData(
          backgroundColor: AppColor.tealNew,
          contentTextStyle: TextStyles.fontCircularSpotify14BlackMedium.copyWith(color: AppColor.whiteColor) ),
      iconTheme: const IconThemeData(color: AppColor.white),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        hintStyle: TextStyles.fontCircularSpotify14WhiteMedium
            .copyWith(fontWeight: FontWeightHelper.regular),
        labelStyle: TextStyles.fontCircularSpotify14WhiteMedium,
        filled: true,
        fillColor: AppColor.textFieldFill,
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
              color: AppColor.textFieldBorder.withOpacity(.8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.grayColor.withOpacity(.2),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.textFieldBorder,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 57,
              fontWeight: FontWeight.normal,
              color: AppColor.ofWhiteColor),
          displayMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 45,
              fontWeight: FontWeight.normal,
              color: AppColor.ofWhiteColor),
          displaySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 36,
              fontWeight: FontWeight.normal,
              color: AppColor.ofWhiteColor),
          headlineLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColor.ofWhiteColor),
          headlineMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.ofWhiteColor),
          headlineSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.tealNew),
          titleLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColor.ofWhiteColor),
          titleMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor),
          titleSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.ofWhiteColor),
          bodyLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColor.ofWhiteColor),
          bodyMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.ofWhiteColor),
          bodySmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColor.ofWhiteColor),
          labelLarge: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.ofWhiteColor),
          labelMedium: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.ofWhiteColor),
          labelSmall: TextStyle(
              fontFamily: "CircularSpotify",
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColor.ofWhiteColor)),
    );
  }
}
