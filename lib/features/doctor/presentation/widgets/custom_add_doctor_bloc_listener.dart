import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAddDoctorBlocListener extends StatelessWidget {
  const CustomAddDoctorBlocListener({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddDoctorCubit,AddDoctorState>(
      listener: (context, state) {
        if(state.isSuccess){
                        context.pushNamedAndRemoveAll(RouteNames.initial);
          // context.pushReplacementNamed(RouteNames.initial);
        }
        if(state.isUploadProfilePictureSuccess){
          context.read<AddDoctorCubit>().addDoctor();
        }
      },
      child: child,
    );
  }
}