import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
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

class SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = 'patient';
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return CustomeSignUpListner(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/sign_up_background.svg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Scaffold(
  backgroundColor: Colors.transparent,
  body: SafeArea(
    child: SingleChildScrollView(
      child: Form(
        key: cubit.formKey,
        child: SizedBox(
          height: MediaQuery.of(context)
                          .size
                          .height, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomeUpperText(),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1A998E),
                          ),
                        ),
                      ),
                      // Role selection
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoleSelectionBox(
                              title: 'Patient',
                              isSelected: selectedRole == 'patient',
                              onTap: () => setState(() => selectedRole = 'patient'),
                            ),
                            SizedBox(width: 20.w),
                            RoleSelectionBox(
                              title: 'Doctor',
                              isSelected: selectedRole == 'doctor',
                              onTap: () => setState(() => selectedRole = 'doctor'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomeSignUpInputFields(),
                      SizedBox(height: 27.h),
                          
                      // Sign-Up Button
                      BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          return state.isLoading
                              ?  Center(
                                child: CircularProgressIndicator(
                                    color: AppColor.teal,
                                  ),
                              )
                              : CustomButton(
                                  buttonText: 'Sign Up',
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
                                      showSnackBar(context, 'Please accept terms and conditions');
                                    }
                                  },
                                );
                        },
                      ),
                      SizedBox(height: 10.h),
                          
                      // Already have an account
                      CustomeAlreadyHaveAnAccountRow(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, RouteNames.signIn);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
        

      )],
      ),
    );
  }
}
class RoleSelectionBox extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionBox({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 150.w,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff1A998E) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? const Color(0xff1A998E) : Colors.grey[200]!,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
