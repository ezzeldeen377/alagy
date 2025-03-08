import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:alagy/core/utils/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/validators.dart';
import '../../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../../cubits/sign_up_cubit/sign_up_state.dart';


class CustomeSignUpInputFields extends StatelessWidget {
  const CustomeSignUpInputFields({super.key,});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SignUpCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          CustomTextFormField(
            validator: emailValidator,
            hint: "Email",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: const Icon(
              Icons.email_outlined,
              color: AppColor.accentBlackColor2,
            ),
            controller: cubit.emailController,
          ),
          SizedBox(
            height: 15.h,
          ),
         
          CustomTextFormField(
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return "Plase enter your username";
              }
              return null;
            },
            hint: "Username",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: const Icon(
              Icons.person,
              color: AppColor.accentBlackColor2,
            ),
            controller: cubit.nameController,
          ),
          SizedBox(
            height: 15.h,
          ),
          
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return CustomTextFormField(
                validator: passwordValidator,
                hint: "Password",
                obscureText: state.isVisiblePassword,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SignUpCubit>().changeVisiblePassword();
                  },
                  icon: Icon(
                    state.isVisiblePassword == true
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor.accentBlackColor2,
                  ),
                ),
                controller: cubit.passwordController,
              );
            },
          ),
          SizedBox(
            height: 15.h,
          ),
     
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return CustomTextFormField(
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please enter your Confirm Password";
                  } else if (value != cubit.passwordController!.text) {
                    return "Password and Confirm Password must be same";
                  }
                  return null;
                },
                hint: "Confirm Password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: state.isVisiblePasswordConfirm,
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SignUpCubit>().changeVisibleConfirmPassword();
                  },
                  icon: Icon(
                    state.isVisiblePasswordConfirm == true
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor.accentBlackColor2,
                  ),
                ),
                controller: cubit.confirmPasswordController,
              );
            },
          ),
          Row(
            children: [
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return Checkbox(
                      value: state.isChecked,
                      onChanged: (value) {
                        context.read<SignUpCubit>().check(value!);
                      });
                },
              ),
              Text(
                'By creating an account, you agree to our',
                style: TextStyles.font11RobotoAccentBlackColor2Regular
                    .copyWith(fontSize: 10.h),
              ),
              InkWell(
                  onTap: () {},
                  child: Text(
                    'Term & Conditions',
                    style: TextStyles.font11RobotoBlueColorRegular
                        .copyWith(fontSize: 10.h),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
