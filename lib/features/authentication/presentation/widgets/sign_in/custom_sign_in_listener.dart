import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../cubits/sign_in_cubit/sign_in_cubit.dart';
import '../../cubits/sign_in_cubit/sign_in_state.dart';

class CustomSignInListener extends StatelessWidget {
  final Widget child;
  const CustomSignInListener({super.key, required this.child});

  Future<void> getUserAndNavToHome(BuildContext context, String uid) async {
    context.read<AppUserCubit>().setUserId(uid);
    await context.read<SignInCubit>().getUser(uid: uid);
    await context
        .read<AppUserCubit>()
        .saveUserData(context.read<SignInCubit>().state.userModel);
    if (context.read<SignInCubit>().state.userModel?.type == Role.doctor.name) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.editDoctor,
        arguments: context.read<SignInCubit>().state.userModel,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.initial,
        arguments: context.read<SignInCubit>().state.userModel,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) async {
        if (state.isSuccessSignIn) {
          getUserAndNavToHome(context, state.uid!);
        }
        if (state.isGoogleAuthSuccess) {
          getUserAndNavToHome(context, state.userModel!.uid);
        }
        if (state.isFailure) {
          showSnackBar(context, state.erorrMessage ?? "Sign-in failed");
          return;
        }
        if (state.isFailure) {
          showSnackBar(context, state.erorrMessage ?? "Sign-in failed");
          return;
        }
        if (state.isGoogleAuthFailure) {
          showSnackBar(
              context, state.erorrMessage ?? "Google authentication failed");
          return;
        }
      },
      child: child,
    );
  }
}
