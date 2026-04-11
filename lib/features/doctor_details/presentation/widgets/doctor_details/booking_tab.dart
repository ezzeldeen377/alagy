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
              state.isDayClosed
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        Icon(
                          Icons.event_busy_outlined,
                          size: 64.r,
                          color: AppColor.greyColor.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          context.l10n.closedOnThisDay,
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            color: AppColor.greyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    )
                  : (state.timeSlots?.isEmpty ?? true)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            Icon(
                              Icons.history_toggle_off_outlined,
                              size: 64.r,
                              color: AppColor.greyColor.withOpacity(0.5),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              context.l10n.noAppointmentsForThisDay,
                              style:
                                  context.theme.textTheme.titleMedium?.copyWith(
                                color: AppColor.greyColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        )
                      : Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: state.timeSlots!.map((time) {
                            final isSelected = state.selectedTime == time;
                            final isAvailable = time.isAvailable;
                            return InkWell(
                              onTap: isAvailable
                                  ? () => cubit.selectTime(time)
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColor.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: !isAvailable
                                        ? AppColor.greyColor.withOpacity(0.5)
                                        : AppColor.primaryColor,
                                  ),
                                ),
                                child: Text(
                                  time.formatLocalized(context
                                      .read<AppSettingsCubit>()
                                      .state
                                      .locale
                                      .languageCode),
                                  style: context.theme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: !isAvailable
                                        ? AppColor.greyColor
                                        : (isSelected ? Colors.white : null),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
                                final user =
                                    context.read<AppUserCubit>().state.user;

                                final appointment = DoctorAppointment(
                                  doctorId: doctor.uid,
                                  doctorName: doctor.name,
                                  patientId: user?.uid ?? "not found",
                                  patientName: user?.name ?? "not found",
                                  specialization:
                                      doctor.specialization ?? "not selected",
                                  appointmentDate:
                                      state.selectedDate!.normalizeDateOnly,
                                  startTime: state.selectedTime!,
                                  status: AppointmentStatus.pending,
                                  appointmentType: appointmentType,
                                  price: price,
                                  paymentStatus:
                                      AppointmentPaymentStatus.unpaid,
                                  createdAt: DateTime.now(),
                                  doctorNotificationToken:
                                      doctor.notificationToken,
                                  patientNotificationToken:
                                      user?.notificationToken,
                                  updatedAt: DateTime.now(),
                                );

                                showConfirmationBottomSheet(
                                    context, appointment, () {});
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
