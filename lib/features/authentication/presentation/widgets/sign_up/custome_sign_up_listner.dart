import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
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
          showSnackBar(context, state.erorrMessage ?? context.l10n.generalError);
        } else if (state.isSuccessSaveData) {
          context.read<AppUserCubit>().onSignOut();
          showCustomDialog(context, context.l10n.createAccountSuccessfully, () {
          context.pushNamed(RouteNames.signIn);
          });
        } else if (state.isSuccessDeleteUser) {
          showSnackBar(context, context.l10n.deleteDataSuccessfully);
        }
      },
      child: child,
    );
  }
}
