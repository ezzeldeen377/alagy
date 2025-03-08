import 'package:alagy/core/helpers/validators.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubits/sign_in_cubit/sign_in_cubit.dart';
import '../../cubits/sign_in_cubit/sign_in_state.dart';

class CustomSignInInputFields extends StatelessWidget {

  const CustomSignInInputFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
          SizedBox(height: 15.h),
          
          BlocBuilder<SignInCubit, SignInState>(
            builder: (context, state) {
              return CustomTextFormField(
                hint: "Password",
                obscureText: state.isVisible,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SignInCubit>().changeVisiblePassword();
                  },
                  icon: Icon(
                    state.isVisible
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor.accentBlackColor2,
                  ),
                ),
                controller: cubit.passwordController,
              );
            },
          ),
        ],
      ),
    );
  }
}
