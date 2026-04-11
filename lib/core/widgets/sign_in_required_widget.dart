import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInRequiredWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? signInButtonText;
  final String? signUpButtonText;
  final VoidCallback? onSignInPressed;
  final VoidCallback? onSignUpPressed;
  final String? signInRoute;
  final String? signUpRoute;

  const SignInRequiredWidget({
    super.key,
    this.title,
    this.subtitle,
    this.signInButtonText,
    this.signUpButtonText,
    this.onSignInPressed,
    this.onSignUpPressed,
    this.signInRoute,
    this.signUpRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = AppColor.primaryColor;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sign In Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32.h),

              // Title
              Text(
                title ?? context.l10n.signInRequiredTitle,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                subtitle ?? context.l10n.signInRequiredSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Inter',
                  height: 1.4,
                ),
              ),
              SizedBox(height: 40.h),

              // Sign In Button
              Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onSignInPressed ??
                      () {
                        Navigator.pushNamed(context, signInRoute ?? '/signIn');
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        signInButtonText ?? context.l10n.signIn,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Sign Up Link
              TextButton(
                onPressed: onSignUpPressed ??
                    () {
                      Navigator.pushNamed(context, signUpRoute ?? '/signUp');
                    },
                child: RichText(
                  text: TextSpan(
                    text: "${context.l10n.dontHaveAccount} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(
                        text: signUpButtonText ?? context.l10n.signUpButton,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
