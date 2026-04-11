import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/notification_service.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctor_details/doctor_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDoctorDetailsBlocListener extends StatelessWidget {
  const CustomDoctorDetailsBlocListener({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorDetailsCubit, DoctorDetailsState>(
      listener: (context, state) {
        if (state.isAppointmentAdded) {
          showSnackBar(context, context.l10n.appointmentAddedSuccessfully);
         
       
          
        }
      },
      child: child,
    );
  }
}
