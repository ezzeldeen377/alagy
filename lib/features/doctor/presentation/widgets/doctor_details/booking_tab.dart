import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkingHours {
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;

  WorkingHours({this.openTime, this.closeTime});
}

class DoctorSchedule {
  final WorkingHours regularHours;
  final WorkingHours fridayHours;

  DoctorSchedule({required this.regularHours, required this.fridayHours});
}

final DoctorSchedule fakeSchedule = DoctorSchedule(
  regularHours: WorkingHours(
    openTime: const TimeOfDay(hour: 9, minute: 0), // 9:00 AM
    closeTime: const TimeOfDay(hour: 17, minute: 0), // 5:00 PM
  ),
  fridayHours: WorkingHours(
    openTime: const TimeOfDay(hour: 10, minute: 0), // 10:00 AM
    closeTime: const TimeOfDay(hour: 14, minute: 0), // 2:00 PM
  ),
);

class BookingTab extends StatelessWidget {
  const BookingTab({super.key});

  List<String> _generateTimeSlots(DateTime selectedDay, BuildContext context) {
    final List<String> timeSlots = [];
    final dayOfWeek = selectedDay.weekday;

    if (dayOfWeek == DateTime.sunday) {
      return timeSlots; // Closed on Sundays
    }

    TimeOfDay? openTime;
    TimeOfDay? closeTime;

    if (dayOfWeek == DateTime.friday) {
      openTime = fakeSchedule.fridayHours.openTime;
      closeTime = fakeSchedule.fridayHours.closeTime;
    } else {
      openTime = fakeSchedule.regularHours.openTime;
      closeTime = fakeSchedule.regularHours.closeTime;
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

      final period =
          hour >= 12 ? context.l10n.pm ?? 'PM' : context.l10n.am ?? 'AM';
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
    DateTime selectedDay = DateTime(2025, 5, 23);
    List<String> timeSlots = _generateTimeSlots(selectedDay, context);
    String? selectedTimeSlot;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  context.l10n.bookAppointment,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                // Date Picker
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.isDark
                            ? Colors.black12.withAlpha(100)
                            : Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EasyDateTimeLinePicker(locale:context.read<AppSettingsCubit>().state.locale,
                        focusedDate: DateTime.now(),
                        firstDate: DateTime(2024, 3, 18),
                        lastDate: DateTime(2030, 3, 18),
                        onDateChange: (date) {
                          // Handle the selected date.
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Time Slots
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.isDark
                            ? Colors.black12.withAlpha(100)
                            : Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.selectDate,
                          style: context.theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      timeSlots.isEmpty
                          ? Center(
                              child: Text(
                                context.l10n.closedOnThisDay,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: timeSlots.map((time) {
                                final isSelected = selectedTimeSlot == time;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedTimeSlot = time;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColor.tealNew
                                          : context
                                              .theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: AppColor.tealNew),
                                    ),
                                    child: Text(time,
                                        style:
                                            context.theme.textTheme.labelLarge),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Book Appointment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedTimeSlot != null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n.featureNotImplemented 
                                  
                                ),
                                backgroundColor: AppColor.tealNew,
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.tealNew,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: AppColor.grayColor,
                    ),
                    child: Text(
                      context.l10n.bookAppointment ?? 'Book Appointment',
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
          ),
        );
      },
    );
  }
}
