import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:alagy/features/settings/cubit/app_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(context.l10n.onboardingWelcome,
                          style: theme.textTheme.headlineLarge)),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/onboarding_1.jpg',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 200.h,
                                color: settingsState.isDarkMode
                                    ? AppColor.darkTeal
                                    : AppColor.tealNew,
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40.sp,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 30.h),
                          Text(l10n.onboardingTitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(color: AppColor.tealNew)),
                          SizedBox(height: 10.h),
                          Text(l10n.onboardingDescription,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AppUserCubit>().saveInstallationFlag();
                        Navigator.pushReplacementNamed(
                            context, RouteNames.signIn);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColor.mintGreen,
                              AppColor.tealNew,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.darkTeal.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.onboardingGetStarted,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium),
                            horizontalSpace(10),
                            const Icon(Icons.arrow_forward, color: AppColor.offWhite)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
