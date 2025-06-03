import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/helpers/validators.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/custom_button.dart';
import 'package:alagy/core/utils/custom_text_form_field.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/authentication/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:alagy/features/authentication/presentation/cubits/forget_password_cubit/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    final theme = context.theme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.forgotPassword,style: theme.textTheme.headlineMedium?.copyWith(color: AppColor.whiteColor),),
        centerTitle: true,
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state.status == ForgetPasswordStatus.success) {
            showCustomSnackBar(
              context: context,
              message: context.l10n.passwordResetEmailSent,
              isError: false,
            );
            Navigator.pop(context);
          }
          
          if (state.status == ForgetPasswordStatus.failure && state.errorMessage != null) {
            showCustomSnackBar(
              context: context,
              message: state.errorMessage!,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      
                      // Header image
                      Center(
                        child: Image.asset(
                          'assets/images/forgot_password.png',
                          height: 180.h,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.lock_reset,
                              size: 100.sp,
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: 30.h),
                      
                      // Instructions text
                      Text(
                        context.l10n.forgotPasswordInstructions,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // Email label
                      Text(
                        context.l10n.signInEmailLabel,
                        style: theme.textTheme.titleSmall,
                      ),
                      
                      verticalSpace(10),
                      
                      // Email input field
                      CustomTextFormField(
                        controller: cubit.emailController,
                        hint: context.l10n.signInEmailHint,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                        suffixIcon: const Icon(Icons.email_outlined),
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],onSubmitted:cubit.emailChanged ,
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // Reset password button
                      CustomButton(
                          onTapButton: state.status == ForgetPasswordStatus.loading 
                              ? null 
                              : cubit.resetPassword,
                        
                          buttonContent: state.status == ForgetPasswordStatus.loading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.onPrimary,
                                    strokeWidth: 2.w,
                                  ),
                                )
                              : Text(
                                  context.l10n.resetPassword,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColor.whiteColor
                                  ),
                                ),
                        ),
                      
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}