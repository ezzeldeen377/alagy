import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/validators.dart';
import 'package:alagy/core/utils/image_picker.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit({required this.repository})
      : super(const AddDoctorState(status: AddDoctorStatus.initial)) {
    _initDayControllers();
  }
  DoctorRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController hospitalOrClinicNameController =
      TextEditingController();
  final TextEditingController yearsOfExperienceController =
      TextEditingController();
  final TextEditingController consultationFeeController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController weeklyStartTimeController =
      TextEditingController();
  final TextEditingController weeklyEndTimeController = TextEditingController();

  @override
  Future<void> close() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    specializationController.dispose();
    qualificationController.dispose();
    licenseNumberController.dispose();
    hospitalOrClinicNameController.dispose();
    yearsOfExperienceController.dispose();
    consultationFeeController.dispose();
    addressController.dispose();
    bioController.dispose();
    weeklyStartTimeController.dispose();
    weeklyEndTimeController.dispose();
    return super.close();
  }

  Future<void> getDoctorDetails(String uid) async {
    emit(state.copyWith(status: AddDoctorStatus.loading));
    final response = await repository.getDoctor(uid);
    response.fold((error) {
      emit(state.copyWith(
          status: AddDoctorStatus.error, errorMessage: error.message));
    }, (success) {
      emit(state.copyWith(status: AddDoctorStatus.loaded, doctor: success));
      initControllers();
    });
  }

  Future<void> addDoctor() async {
    emit(state.copyWith(status: AddDoctorStatus.loading));
    final response = await repository.addDoctor(prepareDoctorData());
    response.fold((error) {
      emit(state.copyWith(
          status: AddDoctorStatus.error, errorMessage: error.message));
    }, (success) {
      emit(state.copyWith(status: AddDoctorStatus.success));
    });
  }

  void updateLocation({double? latitude, double? longitude}) {
    emit(state.copyWith(latitude: latitude, longitude: longitude));
  }

  Future<void> pickPofilePicture() async {
    emit(state.copyWith(status: AddDoctorStatus.pickProfileImageLoading));
    final image = await pickImage();
    if (image != null) {
      emit(state.copyWith(
        status: AddDoctorStatus.pickProfileImageSuccess,
        selectedProfilePicture: image,
      ));
    } else {
      emit(state.copyWith(status: AddDoctorStatus.pickProfileImageError));
    }
  }

  Future<void> uploadProfilePicture() async {
    emit(state.copyWith(status: AddDoctorStatus.uploadProfilePictureLoading));
    final response =
        await repository.uploadProfilePicture(state.selectedProfilePicture!);
    response.fold((error) {
      emit(state.copyWith(
          status: AddDoctorStatus.uploadProfilePictureError,
          errorMessage: error.message));
    }, (url) {
      emit(state.copyWith(
          status: AddDoctorStatus.uploadProfilePictureSuccess,
          profilePictureUrl: url));
    });
  }

  void resetState() {
    emit(const AddDoctorState(status: AddDoctorStatus.initial));
  }

  DoctorModel prepareDoctorData() {
    final doctor = state.doctor;

    return doctor!.copyWith(
        name: nameController.text.isEmpty ? null : nameController.text,
        email: emailController.text.isEmpty ? null : emailController.text,
        phoneNumber: phoneNumberController.text.isEmpty
            ? null
            : phoneNumberController.text,
        address: addressController.text.isEmpty ? null : addressController.text,
        specialization: specializationController.text.isEmpty
            ? null
            : specializationController.text,
        qualification: qualificationController.text.isEmpty
            ? null
            : qualificationController.text,
        licenseNumber: licenseNumberController.text.isEmpty
            ? null
            : licenseNumberController.text,
        hospitalName: hospitalOrClinicNameController.text.isEmpty
            ? null
            : hospitalOrClinicNameController.text,
        createdAt: doctor.createdAt,
        consultationFee: consultationFeeController.text.isEmpty
            ? null
            : double.tryParse(consultationFeeController.text),
        profileImage: state.profilePictureUrl?.isNotEmpty == true
            ? state.profilePictureUrl
            : doctor.profileImage,
        yearsOfExperience: yearsOfExperienceController.text.isEmpty
            ? null
            : int.tryParse(yearsOfExperienceController.text),
        bio: bioController.text.isEmpty ? null : bioController.text,
        uid: doctor.uid,
        type: doctor.type,
        latitude: state.latitude,
        longitude: state.longitude,
        openDurations: AppConstants.daysOfWeek.map((day) {
          final weekTime = Map<String, Map<String, String?>>.from(
              state.dayAvailability ?? {});

          return OpenDuration(
            day: day,
            startTime:
                convertArabicTimeToEnglish(weekTime[day]?['start'] ?? ''),
            endTime: convertArabicTimeToEnglish(weekTime[day]?['end'] ?? ''),
            isClosed: state.dayIsClosed?[day] ?? false,
          );
        }).toList(),
        isSaved: true);
  }

  final Map<String, TextEditingController> dayStartTimeControllers = {};
  final Map<String, TextEditingController> dayEndTimeControllers = {};

  void _initDayControllers() {
    for (var day in AppConstants.daysOfWeek) {
      dayStartTimeControllers[day] =
          TextEditingController(text: state.dayAvailability?[day]?['start']);
      dayEndTimeControllers[day] =
          TextEditingController(text: state.dayAvailability?[day]?['end']);
    }
  }

  void toggleCustomAvailability(bool value) {
    emit(state.copyWith(isCustomAvailability: value));
  }

  void updateWeeklyStartTime(String time) {
    final updatedAvailability =
        Map<String, Map<String, String?>>.from(state.dayAvailability ?? {});
    if (!(state.isCustomAvailability!)) {
      for (var day in AppConstants.daysOfWeek) {
        updatedAvailability[day] = {
          'start': time,
          'end': updatedAvailability[day]?['end'],
        };
        dayStartTimeControllers[day]?.text = time;
      }
    }
    weeklyStartTimeController.text = time;

    emit(state.copyWith(
      weeklyStartTime: time,
      dayAvailability: updatedAvailability,
    ));
  }

  void updateWeeklyEndTime(String time) {
    final updatedAvailability =
        Map<String, Map<String, String?>>.from(state.dayAvailability ?? {});
    if (!(state.isCustomAvailability!)) {
      for (var day in AppConstants.daysOfWeek) {
        updatedAvailability[day] = {
          'start': updatedAvailability[day]?['start'],
          'end': time,
        };
        dayEndTimeControllers[day]?.text = time;
      }
    }
    weeklyEndTimeController.text = time;
    emit(state.copyWith(
      weeklyEndTime: time,
      dayAvailability: updatedAvailability,
    ));
  }

  void updateDayStartTime(String day, String time) {
    final updatedAvailability =
        Map<String, Map<String, String?>>.from(state.dayAvailability ?? {});
    updatedAvailability[day] = {
      'start': time,
      'end': updatedAvailability[day]?['end'],
    };
    dayStartTimeControllers[day]?.text = time;

    emit(state.copyWith(dayAvailability: updatedAvailability));
  }

  void updateDayEndTime(String day, String time) {
    final updatedAvailability =
        Map<String, Map<String, String?>>.from(state.dayAvailability ?? {});
    updatedAvailability[day] = {
      'start': updatedAvailability[day]?['start'],
      'end': time,
    };
    dayEndTimeControllers[day]?.text = time;
    emit(state.copyWith(dayAvailability: updatedAvailability));
  }

  void selectDay(String day) {
    emit(state.copyWith(selectedDay: day));
  }

  void toggleDayAvailability(String day, bool isClosed) {
    final updatedClosedDays = Map<String, bool>.from(state.dayIsClosed ?? {});
    updatedClosedDays[day] = isClosed;
    emit(state.copyWith(dayIsClosed: updatedClosedDays));
  }

  void initControllers() {
      emit(state.copyWith(
      latitude: state.doctor?.latitude,
      longitude: state.doctor?.longitude,
      profilePictureUrl: state.doctor?.profileImage,
      dayAvailability: state.doctor!.mapToDayAvailability(),
      dayIsClosed: state.doctor!.mapToDayIsClosed(),
      
    ));
    nameController.text = state.doctor?.name ?? '';
    emailController.text = state.doctor?.email ?? '';
    phoneNumberController.text = state.doctor?.phoneNumber ?? '';
    addressController.text = state.doctor?.address ?? '';
    specializationController.text = state.doctor?.specialization ?? '';
    qualificationController.text = state.doctor?.qualification ?? '';
    licenseNumberController.text = state.doctor?.licenseNumber ?? '';
    hospitalOrClinicNameController.text = state.doctor?.hospitalName ?? '';
    consultationFeeController.text = (state.doctor?.consultationFee != null
        ? state.doctor!.consultationFee?.toStringAsFixed(0)
        : '')!;
    yearsOfExperienceController.text = state.doctor?.yearsOfExperience != null
        ? state.doctor!.yearsOfExperience.toString()
        : '';
    bioController.text = state.doctor?.bio ?? '';
  
    dayEndTimeControllers.forEach((day, controller) {
      controller.text = state.dayAvailability?[day]?['end']?? '';
    });
    dayStartTimeControllers.forEach((day, controller) {
      controller.text = state.dayAvailability?[day]?['start']?? '';
    });
  }
}


