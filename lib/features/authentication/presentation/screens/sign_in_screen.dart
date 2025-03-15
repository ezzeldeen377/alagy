import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/authentication/presentation/widgets/sign_in/custome_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubits/sign_in_cubit/sign_in_cubit.dart';
import '../cubits/sign_in_cubit/sign_in_state.dart';
import '../../../../core/utils/custom_button.dart';
import '../widgets/sign_in/custom_dont_have_account_row.dart';
import '../widgets/sign_in/custom_sign_in_input_fields.dart';
import '../widgets/sign_in/custom_sign_in_listener.dart';
import '../widgets/sign_up/google_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return CustomSignInListener(
      child: PopScope(
        canPop: false,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeTitleText(
                        title: context.l10n.signInTitle,
                        animatedText: context.l10n.signInWelcomeBack,
                        padding: EdgeInsetsDirectional.only(
                            top: 148.h, bottom: 65.h, end: 35.w, start: 35.w),
                      ),
                      const CustomSignInInputFields(),
                      SizedBox(height: 60.h),
                      Column(
                        children: [
                          BlocBuilder<SignInCubit, SignInState>(
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Center(
                                  child: CustomButton(
                                    buttonContent: state.isLoading ||
                                            state.isAlreadySignIn ||
                                            state.isNotSignIn ||
                                            state.isSuccessSignOut ||
                                            state.isSuccessSignIn ||
                                            state.isSuccessGetData
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            context.l10n.signInButton,
                                            style: context
                                                .theme.textTheme.titleLarge
                                                ?.copyWith(
                                                    color: AppColor.white),
                                          ),
                                    animationIndex: 3,
                                    onTapButton: state.isLoading ||
                                            state.isAlreadySignIn ||
                                            state.isNotSignIn ||
                                            state.isSuccessSignOut ||
                                            state.isSuccessSignIn ||
                                            state.isSuccessGetData
                                        ? null
                                        : () {
                                            if (cubit.formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<SignInCubit>()
                                                  .signIn();
                                            }
                                          },
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 22.h),
                          CustomDontHaveAccountRow(
                            onTap: () {
                              Navigator.pushNamed(context, RouteNames.signUp);
                            },
                          ),
                          verticalSpace(15),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  indent: 20.w,
                                  thickness: 2,
                                  color: context.isDark
                                      ? AppColor.ofWhiteColor
                                      : AppColor.grayColor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  context.l10n.signInDividerOr,
                                  style: context.theme.textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  endIndent: 20.w,
                                  thickness: 2,
                                  color: context.isDark
                                      ? AppColor.ofWhiteColor
                                      : AppColor.grayColor,
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(25),
                          BlocBuilder<SignInCubit, SignInState>(
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: GoogleButton(
                                  isLoading: state.isGoogleAuthLoading,
                                  onTapButton: () {
                                    context.read<SignInCubit>().googleAuth();
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                        ],
                      )
                          .animate()
                          .slideY(
                              begin: 1,
                              end: 0,
                              duration: const Duration(milliseconds: 500),
                              delay:
                                  const Duration(milliseconds: (3) * 200 + 200))
                          .fadeIn(
                              duration: const Duration(milliseconds: 500),
                              delay:
                                  const Duration(milliseconds: (3) * 200 + 200))
                          .then(delay: const Duration(milliseconds: 200)),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
