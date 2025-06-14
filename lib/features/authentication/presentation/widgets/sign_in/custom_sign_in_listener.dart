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

  void _navigateToHome(BuildContext context, UserModel user) {
    if (user.type == Role.doctor.name) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.editDoctor,
        arguments: user,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.initial,
        arguments: user,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
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
      child: BlocListener<AppUserCubit, AppUserState>(
        listener: (context, state) async {
          if (state.isLoggedIn()) {
           await  context.read<AppUserCubit>().getUser(uid: state.userId ?? "");
          }
          if (state.isGettedData()) {
            _navigateToHome(context, state.user!);
          }
          // if (state.isAlreadySignIn) {
          //   signInCubit.signOut();
          //   return;
          // }

          // if (state.isNotSignIn) {
          //   signInCubit.signIn();
          //   return;
          // }

          // if (state.isFailure) {
          //   showSnackBar(context, state.erorrMessage ?? "Sign-in failed");
          //   return;
          // }

          // if (state.isSuccessSignIn) {
          //   if (state.uid?.isNotEmpty ?? false) {
          //     signInCubit.getUser(uid: state.uid!);
          //   } else {
          //     showSnackBar(context, "User ID is missing");
          //   }
          //   return;
          // }

          // if (state.isSuccessGetData) {
          //   await appUserCubit.saveUserData(state.userModel);
          //   _navigateToHome(context,state.userModel!);
          //   return;
          // }

          // if (state.isFailureGetData) {
          //   showSnackBar(context, state.erorrMessage ?? "Failed to retrieve user data");
          //   signInCubit.signOut();
          //   return;
          // }

          // if (state.isGoogleAuthSuccess) {
          //   signInCubit.setUserData(userModel: state.userModel!);
          //   return;
          // }

          // if (state.isSetUserDataSuccess) {
          //   await appUserCubit.saveUserData(state.userModel);
          //   _navigateToHome(context,state.userModel!);
          //   return;
          // }

          // if (state.isGoogleAuthFailure) {
          //   showSnackBar(context, state.erorrMessage ?? "Google authentication failed");
          //   return;
          // }

          // if (state.isSuccessSignOut) {
          //   // Optional: Handle post-logout logic here
          //   return;
          // }
        },
        child: child,
      ),
    );
  }
}
