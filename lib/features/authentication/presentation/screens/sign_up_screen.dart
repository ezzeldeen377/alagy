import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/font_weight_helper.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/authentication/presentation/widgets/sign_in/custome_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../cubits/sign_up_cubit/sign_up_state.dart';
import '../../../../core/utils/custom_button.dart';
import '../widgets/sign_up/custome_already_have_an_account_row.dart';
import '../widgets/sign_up/custome_sign_up_input_fields.dart';
import '../widgets/sign_up/custome_sign_up_listner.dart';
import '../widgets/sign_up/custome_upper_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedRole = 'patient';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedRole = _tabController.index == 0 ? 'patient' : 'doctor';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return CustomeSignUpListner(
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeTitleText(
                        title: context.l10n.signUpTitle,
                        animatedText: context.l10n.signUpSubtitle,
                        padding: EdgeInsetsDirectional.only(
                            top: 35.h, bottom: 65.h, end: 35.w, start: 35.w),
                      ),
                     Container(
                            // padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                            height: 60.h,
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(
                                    color: AppColor.lgGreyColor, width: .5)),
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 5.h),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerHeight: 0,
                              indicator: BoxDecoration(
                                color: AppColor.tealNew,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              labelColor: AppColor.ofWhiteColor,
                              unselectedLabelColor:context.isLight? Colors.black:AppColor.ofWhiteColor,
                              labelStyle: context.theme.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeightHelper.bold),
                              tabs: [
                                Tab(text: context.l10n.patientTab),
                                Tab(text: context.l10n.doctorTab),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.h),
                          SizedBox(
                            height: 460.h,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Patient Form
                                CustomeSignUpInputFields(
                                  onSubmit: () =>(){},
                                ),
                                // Doctor Form
                                CustomeSignUpInputFields(
                                  onSubmit: () => (){}),
                                
                              ],
                            ),
                          ),
                          
                      // Sign-Up Button
                      Column(
                        children: [
                          BlocBuilder<SignUpCubit, SignUpState>(
                            builder: (context, state) {
                              return state.isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(
                                        color: AppColor.teal,
                                      ),
                                  )
                                  : CustomButton(
                                      buttonText: context.l10n.signUpButton,
                                      animationIndex: 3,
                                      onTapButton: () {
                                        if (state.isChecked == true) {
                                          if (cubit.formKey.currentState!.validate()) {
                                            cubit.signUp(
                                              name: cubit.nameController.text,
                                              email: cubit.emailController.text,
                                              password: cubit.passwordController.text,
                                              type: selectedRole,
                                            );
                                          }
                                        } else {
                                          showSnackBar(context, context.l10n.termsAndConditionsError);
                                        }
                                      },
                                    );
                            },
                          ),
                                              verticalSpace(15),
                              CustomeAlreadyHaveAnAccountRow(onTap: () {  },),
                        ],
                      ).animate()
          .slideY(begin: 1, end: 0, duration: const Duration(milliseconds: 500), delay: Duration(milliseconds: (4 ) * 200 + 200))
          .fadeIn(duration: const Duration(milliseconds: 500), delay: Duration(milliseconds: (4 ) * 200 + 200))
          .then(delay: const Duration(milliseconds: 200)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}

//  const CustomeSignUpInputFields(),
//                           SizedBox(height: 27.h),

//                           // Sign-Up Button
//                           BlocBuilder<SignUpCubit, SignUpState>(
//                             builder: (context, state) {
//                               return state.isLoading
//                                   ? const Center(
//                                       child: CircularProgressIndicator(
//                                         color: AppColor.teal,
//                                       ),
//                                     )
//                                   : CustomButton(
//                                       buttonText: context.l10n.signUpButton,
//                                       onTapButton: () {
//                                         if (state.isChecked == true) {
//                                           if (cubit.formKey.currentState!
//                                               .validate()) {
//                                             cubit.signUp(
//                                               name: cubit.nameController.text,
//                                               email: cubit.emailController.text,
//                                               password:
//                                                   cubit.passwordController.text,
//                                               type: selectedRole,
//                                             );
//                                           }
//                                         } else {
//                                           showSnackBar(context,
//                                               'Please accept terms and conditions');
//                                         }
//                                       },
//                                     );
//                             },
//                           ),
//                           SizedBox(height: 10.h),

//                           // Already have an account
//                           CustomeAlreadyHaveAnAccountRow(
//                             onTap: () {
//                               Navigator.pushReplacementNamed(
//                                   context, RouteNames.signIn);
//                             },
//                           ),