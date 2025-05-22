import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/utils/image_picker.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_repository.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit({required this.repository})
      : super(const AddDoctorState(status: AddDoctorStatus.initial));
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
    return super.close();
  }

  Future<void> getDoctorDetails(String uid) async {
    emit(state.copyWith(status: AddDoctorStatus.loading));
    final response = await repository.getDoctor(uid);
    response.fold((error) {
      emit(state.copyWith(
          status: AddDoctorStatus.error, errorMessage: error.message));
    }, (success) {
      emit(state.copyWith(status: AddDoctorStatus.initial, doctor: success));
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
        phoneNumber: phoneNumberController.text.isEmpty ? null : phoneNumberController.text,
        address: addressController.text.isEmpty ? null : addressController.text,
        specialization: specializationController.text.isEmpty ? null : specializationController.text,
        qualification: qualificationController.text.isEmpty ? null : qualificationController.text,
        licenseNumber: licenseNumberController.text.isEmpty ? null : licenseNumberController.text,
        hospitalName: hospitalOrClinicNameController.text.isEmpty ? null : hospitalOrClinicNameController.text,
        createdAt: doctor?.createdAt ?? DateTime.now(),
        consultationFee: consultationFeeController.text.isEmpty
            ? null
            : double.tryParse(consultationFeeController.text),
        profileImage: state.profilePictureUrl?.isNotEmpty == true
            ? state.profilePictureUrl
            : doctor?.profileImage,
        yearsOfExperience: yearsOfExperienceController.text.isEmpty
            ? null
            : int.tryParse(yearsOfExperienceController.text),
        bio: bioController.text.isEmpty ? null : bioController.text,
        uid: doctor.uid,
        type: doctor.type,
        latitude: state.latitude,
        longitude: state.longitude,
        isSaved: true
      );
  }

  void initControllers() {
    nameController.text = state.doctor?.name ?? '';
    emailController.text = state.doctor?.email ?? '';
    phoneNumberController.text = state.doctor?.phoneNumber ?? '';
    addressController.text = state.doctor?.address ?? '';
    specializationController.text = state.doctor?.specialization ?? '';
    qualificationController.text = state.doctor?.qualification ?? '';
    licenseNumberController.text = state.doctor?.licenseNumber ?? '';
    hospitalOrClinicNameController.text = state.doctor?.hospitalName ?? '';
    consultationFeeController.text =
        (state.doctor?.consultationFee != null ? state.doctor!.consultationFee?.toStringAsFixed(0) : '')!;
    yearsOfExperienceController.text =
        state.doctor?.yearsOfExperience != null ? state.doctor!.yearsOfExperience.toString() : '';
    bioController.text = state.doctor?.bio ?? '';
  }
}