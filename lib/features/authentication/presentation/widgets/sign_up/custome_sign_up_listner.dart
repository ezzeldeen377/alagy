import 'package:alagy/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../../cubits/sign_up_cubit/sign_up_state.dart';

class CustomeSignUpListner extends StatelessWidget {
  final Widget child;
  const CustomeSignUpListner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.isFailure) {
          showSnackBar(context, state.erorrMessage ?? "");
        } else if (state.isSuccess) {
          cubit.setData(userModel: state.userModel!);
        } else if (state.isFailureSaveData) {
          state.erorrMessage;
          cubit.deleteUser(uid: state.userModel?.uid ?? "");
          showSnackBar(context, state.erorrMessage ?? "error");
        } else if (state.isSuccessSaveData) {
          cubit.sendVerificationEmail();
          cubit.signOut();
          showCustomDialog(context,
              "your account has been created successfully, please verify your email",
              () {
            Navigator.pushReplacementNamed(context, RouteNames.signIn);
          });
        } else if (state.isSuccessDeleteUser) {
          showSnackBar(context, "delete data Successfully");
        }
      },
      child: child,
    );
  }
}
