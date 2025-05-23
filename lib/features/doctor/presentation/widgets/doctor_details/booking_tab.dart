import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';

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
                  context.l10n.bookAppointment ?? 'Book an Appointment',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF424242), // Colors.grey[800]
                  ),
                ),
                const SizedBox(height: 16),
                // Date Picker
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.selectDate ?? 'Select Date',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242), // Colors.grey[800]
                        ),
                      ),
                      const SizedBox(height: 12),
                      EasyDateTimeLinePicker(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.selectTime ?? 'Select Time',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242), // Colors.grey[800]
                        ),
                      ),
                      const SizedBox(height: 12),
                      timeSlots.isEmpty
                          ? Center(
                              child: Text(
                                context.l10n.closedOnThisDay ??
                                    'Closed on this day',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF757575), // Colors.grey[600]
                                  fontStyle: FontStyle.italic,
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
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColor.tealNew
                                            : Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
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
                                  context.l10n.featureNotImplemented ??
                                      'Booking not implemented',
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
                      disabledBackgroundColor: Colors.grey[300],
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
