import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/helpers/validators.dart';
import '../../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../../cubits/sign_up_cubit/sign_up_state.dart';

class CustomeSignUpInputFields extends StatelessWidget {
  final Function onSubmit;
  const CustomeSignUpInputFields({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SignUpCubit>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.signUpEmailLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          verticalSpace(10),
          CustomTextFormField(
            validator: emailValidator,
            hint: l10n.signUpEmailHint,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: const Icon(
              Icons.email_outlined,
            ),
            controller: cubit.emailController,
            animationIndex: 0,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
          SizedBox(height: 15.h),
          Text(
            l10n.signUpUsernameLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          verticalSpace(10),
          CustomTextFormField(
            validator: emptyValidator,
            hint: l10n.signUpUsernameHint,
            keyboardType: TextInputType.name,
            suffixIcon: const Icon(
              Icons.person,
            ),
            controller: cubit.nameController,
            animationIndex: 1,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
          ),
          SizedBox(height: 15.h),
          Text(
            l10n.signUpPasswordLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          verticalSpace(10),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return CustomTextFormField(
                validator: passwordValidator,
                hint: l10n.signUpPasswordHint,
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
                  ),
                ),
                controller: cubit.passwordController,
                animationIndex: 2,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
              );
            },
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            l10n.signUpConfirmPasswordLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          verticalSpace(10),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return CustomTextFormField(
                animationIndex: 3,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.signUpConfirmPasswordError;
                  } else if (value != cubit.passwordController.text) {
                    return l10n.signUpPasswordMismatchError;
                  }
                  return null;
                },
                hint: l10n.signUpConfirmPasswordHint,
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
                  ),
                ),
                controller: cubit.confirmPasswordController,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
              );
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return Checkbox(
                    activeColor: AppColor.tealNew,
                    value: state.isChecked,
                    onChanged: (value) {
                      context.read<SignUpCubit>().check(value!);
                    },
                  );
                },
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      l10n.signUpTermsText,
                      style: context.theme.textTheme.bodySmall
                          ?.copyWith(fontSize: 10.h),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigate to Terms & Conditions page if needed
                      },
                      child: Text(
                        l10n.signUpTermsLink,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.h, color: AppColor.blueColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
