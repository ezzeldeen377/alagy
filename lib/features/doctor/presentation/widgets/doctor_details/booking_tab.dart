import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_details/doctor_details_state.dart';
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

  List<String> _generateTimeSlots(
      DateTime selectedDay, BuildContext context, DoctorModel doctor) {
    final List<String> timeSlots = [];

    final selectedDayName = DateFormat('EEEE').format(selectedDay);

    final openDuration = doctor.openDurations?.firstWhere(
      (element) => selectedDayName == element.day,
      orElse: () =>
          OpenDuration(day: selectedDayName, startTime: null, endTime: null),
    );

    TimeOfDay? openTime;
    TimeOfDay? closeTime;

    if (openDuration?.startTime != null &&
        openDuration!.startTime!.isNotEmpty) {
      final startDate = DateFormat.jm().parse(openDuration.startTime!);
      openTime = TimeOfDay(hour: startDate.hour, minute: startDate.minute);
    }

    if (openDuration?.endTime != null && openDuration!.endTime!.isNotEmpty) {
      final endDate = DateFormat.jm().parse(openDuration.endTime!);
      closeTime = TimeOfDay(hour: endDate.hour, minute: endDate.minute);
    }
    if (openTime == null || closeTime == null) {
      return timeSlots;
    }

    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;

    final totalMinutes = closeMinutes <= openMinutes
        ? (24 * 60 - openMinutes) + closeMinutes
        : closeMinutes - openMinutes;

    for (int offset = 0; offset + 60 <= totalMinutes; offset += 60) {
      int minutes = (openMinutes + offset) % (24 * 60);
      final hour = minutes ~/ 60;
      final minute = minutes % 60;

      final period = hour >= 12 ? context.l10n.pm : context.l10n.am;
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      final formattedTime =
          '$displayHour:${minute.toString().padLeft(2, '0')} $period';
      timeSlots.add(formattedTime);
    }

    return timeSlots;
  }

  @override
  Widget build(BuildContext context) {
    // Use May 23, 2025, as the initial date (current date)
    final doctor = context.read<DoctorDetailsCubit>().state.selectedDoctor;

    DateTime selectedDay = DateTime.now();
    List<String> timeSlots = _generateTimeSlots(selectedDay, context, doctor!);
    String? selectedTimeSlot;

    return BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
  builder: (context, state) {
    final cubit = context.read<DoctorDetailsCubit>();

    return Column(
      children: [
        EasyDateTimeLinePicker(
          locale: context.read<AppSettingsCubit>().state.locale,
          focusedDate: state.selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030, 3, 18),
          onDateChange: (date) {
            cubit.changeDate(date,);
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.timeSlots.map((time) {
            final isSelected = state.selectedTime == time;
            return InkWell(
              onTap: () => cubit.selectTime(time),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.primaryColor),
                ),
                child: Text(time,
                    style: context.theme.textTheme.labelLarge?.copyWith(
                      color: isSelected ? Colors.white : null,
                    )),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.selectedTime != null ? () {
                       if(context.read<AppUserCubit>().state.isNotLogin){
                        showLoginDialog(context);
                        return;
                       }
                  } : null,
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
    );
  },
);
  }
}
