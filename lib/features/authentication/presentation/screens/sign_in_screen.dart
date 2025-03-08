import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/authentication/presentation/widgets/sign_in/custome_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../cubits/sign_in_cubit/sign_in_cubit.dart';
import '../cubits/sign_in_cubit/sign_in_state.dart';
import '../../../../core/utils/custom_button.dart';
import '../widgets/sign_in/custom_dont_have_account_row.dart';
import '../widgets/sign_in/custom_sign_in_input_fields.dart';
import '../widgets/sign_in/custom_sign_in_listener.dart';
import '../widgets/sign_up/google_button.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/signIn';
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();

    return CustomSignInListener(
      child: PopScope(
        canPop: false,
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/sign_in_background.svg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Form(
                    key: cubit.formKey,
                    child: SizedBox(
                      height: MediaQuery.of(context)
                          .size
                          .height, // Set the full height of the screen
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomeTitleText(),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 20.h),
                              decoration: BoxDecoration(
                                color: const Color(0xffE2F7F7),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.w),
                                  topRight: Radius.circular(50.w),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 20.h),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 40.sp,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1A998E),
                                      ),
                                    ),
                                  ),
                                  CustomSignInInputFields(),
                                  SizedBox(height: 60.h),
                                  BlocBuilder<SignInCubit, SignInState>(
                                    builder: (context, state) {
                                      return state.isLoading ||
                                              state.isAlreadySignIn ||
                                              state.isNotSignIn ||
                                              state.isSuccessSignOut ||
                                              state.isSuccessSignIn ||
                                              state.isSuccessGetData
                                          ? const Center(
                                            child: CircularProgressIndicator(
                                                color: AppColor.teal
                                                    ,
                                              ),
                                          )
                                          : Padding(
                                            padding:  EdgeInsets.symmetric(horizontal:  20.w),
                                            child: Center(
                                              child: CustomButton(
                                                  buttonText: 'Sign In',
                                                  onTapButton: () {
                                                    if (cubit
                                                        .formKey.currentState!
                                                        .validate()) {
                                                      context
                                                          .read<SignInCubit>()
                                                          .checkUesrSignin(
                                                            email: cubit
                                                                .emailController!
                                                                .text,
                                                            password: cubit
                                                                .passwordController!
                                                                .text,
                                                          );
                                                    }
                                                  },
                                                ),
                                            ),
                                          );
                                    },
                                  ),
                                  SizedBox(height: 22.h),
                                  BlocBuilder<SignInCubit, SignInState>(
                                    builder: (context, state) {
                                      return state.isGoogleAuthLoading
                                          ? const Center(
                                            child: CircularProgressIndicator(
                                                color: AppColor.teal,
                                              ),
                                          )
                                          : Padding(
                                            padding:  EdgeInsets.symmetric(horizontal:  30.w),
                                            child: GoogleButton(
                                                onTapButton: () {
                                                  context
                                                      .read<SignInCubit>()
                                                      .googleAuth();
                                                },
                                              ),
                                          );
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomDontHaveAccountRow(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RouteNames.signUp);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
