import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/settings/cubit/change_password_cubit.dart';
import 'package:alagy/features/settings/cubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.changePassword),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const _ChangePasswordForm(),
      ),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.status == ChangePasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error')),
          );
        } else if (state.status == ChangePasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.passwordChangedSuccessfully)),
          );
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCurrentPasswordField(),
              SizedBox(height: 16.h),
              _buildNewPasswordField(),
              SizedBox(height: 16.h),
              _buildConfirmPasswordField(),
              SizedBox(height: 24.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordField() {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return TextFormField(
          controller: _currentPasswordController,
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            labelText: context.l10n.currentPassword,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => context
                  .read<ChangePasswordCubit>()
                  .togglePasswordVisibility(),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.validatorEnterPassword;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildNewPasswordField() {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return TextFormField(
          controller: _newPasswordController,
          obscureText: !state.isNewPasswordVisible,
          decoration: InputDecoration(
            labelText: context.l10n.newPassword,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                state.isNewPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => context
                  .read<ChangePasswordCubit>()
                  .toggleNewPasswordVisibility(),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.validatorEnterPassword;
            }
            if (value.length < 8) {
              return context.l10n.validatorPasswordTooShort;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return TextFormField(
          controller: _confirmPasswordController,
          obscureText: !state.isConfirmPasswordVisible,
          decoration: InputDecoration(
            labelText: context.l10n.confirmNewPassword,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                state.isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => context
                  .read<ChangePasswordCubit>()
                  .toggleConfirmPasswordVisibility(),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.validatorEnterPassword;
            }
            if (value != _newPasswordController.text) {
              return context.l10n.passwordsDoNotMatch;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: state.status == ChangePasswordStatus.loading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ChangePasswordCubit>().changePassword(
                            currentPassword: _currentPasswordController.text,
                            newPassword: _newPasswordController.text,
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: state.status == ChangePasswordStatus.loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    context.l10n.changePassword,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
