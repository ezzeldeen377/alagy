import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to Pulse Max',
      'description': 'We provide the best health solutions, right at your fingertips.',
      'image': 'assets/images/onboarding_1.jpg', // Update with actual image
    },
    {
      'title': 'Track Your Health',
      'description': 'Monitor your health progress and stay on top of your fitness goals.',
      'image': 'assets/images/onboarding_2.jpg', // Update with actual image
    },
    {
      'title': 'Get Expert Advice',
      'description': 'Consult with doctors and specialists with just a few taps.',
      'image': 'assets/images/onboarding_3.jpg', // Update with actual image
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Onboarding',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A998E),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   onboardingData[index]['image']!,
                        //   width: double.infinity,
                        //   fit: BoxFit.fitWidth,
                        // ),
                        SizedBox(height: 30.h),
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1A998E),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          onboardingData[index]['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage != 0)
                    GestureDetector(
                      onTap: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xff1A998E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        height: 10.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? const Color(0xff1A998E)
                              : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (currentPage == onboardingData.length - 1) {
                        // Navigate to the next screen
                              context.read<AppUserCubit>().saveInstallationFlag();

                        Navigator.pushReplacementNamed(context, RouteNames.signIn);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      currentPage == onboardingData.length - 1 ? 'Finish' : 'Next',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xff1A998E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}