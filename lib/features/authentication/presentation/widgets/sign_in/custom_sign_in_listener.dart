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

  @override
  Widget build(BuildContext context) {
    final appUserCubit = context.read<AppUserCubit>();
    final signInCubit = context.read<SignInCubit>();

    // checkuser signin --> if user signin --> signout --> user signin again --> get user data --> save user data

    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) async {
        if (state.isAlreadySignIn) {
          signInCubit.signOut();
        } else if (state.isNotSignIn) {
          signInCubit.signIn();
        } else if (state.isSuccessSignOut) {
          // signInCubit.signIn();
        } else if (state.isFailure) {
          showSnackBar(context, state.erorrMessage ?? "");
        } else if (state.isSuccessSignIn) {
          signInCubit.getUser(uid: state.uid ?? "");
        } else if (state.isSuccessGetData) {
          await appUserCubit.saveUserData(state.userModel);
         Navigator.pushNamedAndRemoveUntil(context,RouteNames.initial, (route) => false);
        } else if (state.isFailureGetData) {
          showSnackBar(context, state.erorrMessage ?? "");
          signInCubit.signOut();
        } else if (state.isGoogleAuthSuccess) {
          signInCubit.setUserData(userModel: state.userModel!); // to firestore
        } else if (state.isSetUserDataSuccess) {
          await appUserCubit.saveUserData(state.userModel);// local
         Navigator.pushNamedAndRemoveUntil(context,RouteNames.initial, (route) => false);
          
        } else if (state.isGoogleAuthFailure) {
          showSnackBar(context, state.erorrMessage ?? "");
          signInCubit.signOut();
        }
      },
      child: child,
    );
  }
}
