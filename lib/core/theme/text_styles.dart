import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static  TextStyle fontCircularSpotify20WhiteSemiBold = GoogleFonts.cairo(
    fontSize: 20.h,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle fontCircularSpotify14WhiteMedium = GoogleFonts.cairo(
    fontSize: 14.h,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
  static  TextStyle fontCircularSpotify14BlackMedium = GoogleFonts.cairo(
    fontSize: 14.h,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  static  TextStyle fontCircularSpotify12GreyRegular = GoogleFonts.cairo(
    fontSize: 12.h,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );
  static  TextStyle fontCircularSpotify14BlackRegular = GoogleFonts.cairo(
    fontSize: 14.h,
    fontWeight: FontWeight.w400,
  );
  static  TextStyle fontCircularSpotify14LightBlackMedium = GoogleFonts.cairo(
    fontSize: 14.h,
    color: Colors.black54,
    fontWeight: FontWeight.w500,
  );
  static  TextStyle fontCircularSpotify11AccentBlackRegular = GoogleFonts.cairo(
    fontSize: 11.h,
    color: Color(0xFF424242),
    fontWeight: FontWeight.w400,
  );
  static  TextStyle fontCircularSpotify28PrimaryBold = GoogleFonts.cairo(
    fontSize: 28.h,
    color:AppColor.primaryColor,
    fontWeight: FontWeight.bold,
  );

  static  TextStyle fontCircularSpotify11BlueRegular = GoogleFonts.cairo(
    fontSize: 11.h,
    color: Color.fromARGB(255, 74, 35, 248),
    fontWeight: FontWeight.w400,
  );
  static  TextStyle fontCircularSpotify14DarkGreenMedium = GoogleFonts.cairo(
    fontSize: 14.h,
    color: AppColor.primaryColor,
    fontWeight: FontWeight.w500,
  );
}