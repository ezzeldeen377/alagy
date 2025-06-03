import 'package:flutter/material.dart';

class AppColor {
 static const Color primaryColor=Color(0xff5271ff);
  static const Color thirdolor=Color(0xff8ab1ff);// Main color for a branded feel

 static const Color secondryColor=Color(0xff6b93ff);// Main color for a branded feel

 static const Color fourthColor=Color(0xffa3d3ff);// Main color for a branded feel

 static const Color fifthColor=Color(0xffc2e1ff);
  static const Color whiteColor=Color(0xffffffff);
  
 static const Color blackColor=Color(0xff171217);
 static const Color redColor=Color.fromARGB(255, 224, 37, 37);
 static const Color greyColor=Color.fromARGB(255, 136, 134, 134);
 static const Color goldColor=Colors.yellow;

// Main color for a branded feel

static const LinearGradient appGradientBackground = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [
    secondryColor, // primaryColor
   // fourthColor
    Color(0xffc2e1ff), // fifthColor
  ],
);

static  LinearGradient sliderbackground = LinearGradient(
colors: [                  thirdolor.withOpacity(0.05),

                   fourthColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
);

// Main color for a branded feel
}
