import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/helpers/validators.dart';
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
          Text(
            context.l10n.signInEmailLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          verticalSpace(10),
          CustomTextFormField(
            animationIndex: 0,
            validator: emailValidator,
            hint: context.l10n.signInEmailHint,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: const Icon(
              Icons.email_outlined,
            ),
            controller: cubit.emailController,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
          SizedBox(height: 15.h),
          Text(
            context.l10n.signInPasswordLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          verticalSpace(10),
          BlocBuilder<SignInCubit, SignInState>(
            builder: (context, state) {
              return CustomTextFormField(
                animationIndex: 1,
              validator: emptyValidator,
                hint: context.l10n.signInPasswordHint,
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
                  ),
                ),
                controller: cubit.passwordController,
                onSubmitted: (value) {
                  if (cubit.formKey.currentState!.validate()) {
                    context.read<SignInCubit>().checkUesrSignin(
                          email: cubit.emailController.text,
                          password: cubit.passwordController.text,
                        );
                  }
                  print("done");
                },
                textInputAction: TextInputAction.done,
              );
            },
          ),
        ],
      ),
    );
  }
}
