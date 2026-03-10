import 'dart:developer';

import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctor_details/doctor_details_state.dart';
import 'package:alagy/features/doctor_details/presentation/widgets/appointment_type_bottom_sheet.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookingTab extends StatelessWidget {
  const BookingTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use May 23, 2025, as the initial date (current date)
    final doctor = context.read<DoctorDetailsCubit>().state.selectedDoctor;


    return BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
      builder: (context, state) {
        final cubit = context.read<DoctorDetailsCubit>();

        return SingleChildScrollView(
          child: Column(
            children: [
              EasyDateTimeLinePicker(
                locale: context.read<AppSettingsCubit>().state.locale,
                focusedDate: state.selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030, 3, 18),
                onDateChange: (date) {
                  cubit.changeDate(
                    date,
                  );
                },
              ),
              const SizedBox(height: 16),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.timeSlots!.map((time) {
                    final isSelected = state.selectedTime == time;
                    final isAvailable = time.isAvailable;
                    print("@@@@@@@@@@@@@@@@@@@@@@@@$isAvailable");
                    return InkWell(
                      onTap: isAvailable ? () => cubit.selectTime(time) : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColor.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: !isAvailable
                                ? Colors.red
                                : AppColor.primaryColor,
                          ),
                        ),
                        child: Text(
                          time.time,
                          style: context.theme.textTheme.labelLarge?.copyWith(
                            color: !isAvailable
                                ? Colors.red
                                : (isSelected ? Colors.white : null),
                          ),
                        ),
                      ),
                    );
                  }).toList()),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.selectedTime != null
                      ? () {
                          if (context.read<AppUserCubit>().state.isNotLogin) {
                            showLoginDialog(context);
                            return;
                          }
                          
                          // Show appointment type selection bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AppointmentTypeBottomSheet(
                              doctor: doctor!,
                              onTypeSelected: (appointmentType, price) {
                                final user = context.read<AppUserCubit>().state.user;
                                
                                final appointment = DoctorAppointment(
                                  doctorId: doctor.uid,
                                  doctorName: doctor.name,
                                  patientId: user?.uid ?? "not found",
                                  patientName: user?.name ?? "not found",
                                  specialization: doctor.specialization ?? "not selected",
                                  appointmentDate: state.selectedDate!.normalizeDateOnly,
                                  startTime: state.selectedTime!,
                                  status: AppointmentStatus.pending,
                                  appointmentType: appointmentType,
                                  price: price,
                                  paymentStatus: PaymentStatus.unpaid,
                                  createdAt: DateTime.now(),
                                  doctorNotificationToken: doctor.notificationToken,
                                  patientNotificationToken: user?.notificationToken,
                                  updatedAt: DateTime.now(),
                                );
                                
                                showConfirmationBottomSheet(context, appointment, () {});
                              },
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColor.greyColor,
                  ),
                  child: Text(
                    context.l10n.bookAppointment,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
