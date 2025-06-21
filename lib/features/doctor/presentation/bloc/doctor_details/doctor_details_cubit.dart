import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'doctor_details_state.dart';

@injectable
class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final DoctorRepository _doctorRepository;

  DoctorDetailsCubit(this._doctorRepository) : super(const DoctorDetailsState());
  final ratingCommentController = TextEditingController();
  final GlobalKey<FormState> ratingFormKey = GlobalKey<FormState>();
  final GlobalKey targetKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  void passDoctor(DoctorModel doctor) {
    emit(state.copyWith(selectedDoctor: doctor));
  }
  void selectRating(int rating) {
    emit(state.copyWith(userRate: rating));
  }
  Future<void> addReview(Review review) async {
    setLoading();
    final response=await _doctorRepository.addReview(review, state.selectedDoctor!.rating??0);
    response.fold((l) => setError(l.message), (r) {
      setSuccess(doctor: r);
    });
  }
  void changeDate(DateTime date,) {
    final doctor = state.selectedDoctor;
    final timeSlots = _generateTimeSlots(date,doctor!);
    emit(state.copyWith(selectedDate: date, timeSlots: timeSlots, selectedTime: null));
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: time));
  }

  List<String> _generateTimeSlots(DateTime selectedDay, DoctorModel doctor) {
    final List<String> timeSlots = [];
    final selectedDayName = DateFormat('EEEE').format(selectedDay);

    final openDuration = doctor.openDurations?.firstWhere(
      (element) => selectedDayName == element.day,
      orElse: () => OpenDuration(day: selectedDayName, startTime: null, endTime: null),
    );

    TimeOfDay? openTime;
    TimeOfDay? closeTime;

    if (openDuration?.startTime != null && openDuration!.startTime!.isNotEmpty) {
      final startDate = DateFormat.jm().parse(openDuration.startTime!);
      openTime = TimeOfDay(hour: startDate.hour, minute: startDate.minute);
    }

    if (openDuration?.endTime != null && openDuration!.endTime!.isNotEmpty) {
      final endDate = DateFormat.jm().parse(openDuration.endTime!);
      closeTime = TimeOfDay(hour: endDate.hour, minute: endDate.minute);
    }

    if (openTime == null || closeTime == null) return timeSlots;

    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;

    final totalMinutes = closeMinutes <= openMinutes
        ? (24 * 60 - openMinutes) + closeMinutes
        : closeMinutes - openMinutes;

    for (int offset = 0; offset + 60 <= totalMinutes; offset += 60) {
      int minutes = (openMinutes + offset) % (24 * 60);
      final hour = minutes ~/ 60;
      final minute = minutes % 60;

      final period = hour >= 12 ? "pm" : "am";
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      final formattedTime = '$displayHour:${minute.toString().padLeft(2, '0')} $period';
      timeSlots.add(formattedTime);
    }

    return timeSlots;
  }

  void reset() {
    emit(const DoctorDetailsState());
  }

  void setError(String message) {
    emit(state.copyWith(
      status: DoctorDetailsStatus.error,
      errorMessage: message,
    ));
  }

  void setLoading() {
    emit(state.copyWith(status: DoctorDetailsStatus.loading));
  }

  void setSuccess({DoctorModel? doctor}) {
    emit(state.copyWith(status: DoctorDetailsStatus.success,selectedDoctor: doctor));
  }
}