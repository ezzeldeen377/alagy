// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';

enum AddDoctorStatus{
  initial,
  success,
  error,
  loading,
  pickProfileImageLoading,
  pickProfileImageError,
  pickProfileImageSuccess,
  uploadProfilePictureLoading,
  uploadProfilePictureError,
  uploadProfilePictureSuccess,

}
extension AddDoctorStateX on AddDoctorState {
  bool get isInitial => status == AddDoctorStatus.initial;
  bool get isSuccess => status == AddDoctorStatus.success;
  bool get isError => status == AddDoctorStatus.error;
  bool get isLoading => status == AddDoctorStatus.loading;
  bool get isPickProfileImageLoading => status == AddDoctorStatus.pickProfileImageLoading;
  bool get isPickProfileImageSuccess => status == AddDoctorStatus.pickProfileImageSuccess;
  bool get isPickProfileImageError => status == AddDoctorStatus.pickProfileImageError;
  bool get isUploadProfilePictureLoading => status == AddDoctorStatus.uploadProfilePictureLoading;
  bool get isUploadProfilePictureSuccess => status == AddDoctorStatus.uploadProfilePictureSuccess;
  bool get isUploadProfilePictureError => status == AddDoctorStatus.uploadProfilePictureError;


}
class AddDoctorState {
final AddDoctorStatus status;
final DoctorModel? doctor;
final String? errorMessage;
final File? selectedProfilePicture;
final String? profilePictureUrl;


  const AddDoctorState({
    required this.status,
    this.doctor,
    this.errorMessage,
    this.selectedProfilePicture,
    this.profilePictureUrl,
  });

  AddDoctorState copyWith({
    AddDoctorStatus? status,
    DoctorModel? doctor,
    String? errorMessage,
    File? selectedProfilePicture,
    String? profilePictureUrl,
  }) {
    return AddDoctorState(
      status: status ?? this.status,
      doctor: doctor ?? this.doctor,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedProfilePicture: selectedProfilePicture ?? this.selectedProfilePicture,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  

  @override
  String toString() {
    return 'AddDoctorState(status: $status, doctor: $doctor, errorMessage: $errorMessage, selectedProfilePicture: $selectedProfilePicture, profilePictureUrl: $profilePictureUrl)';
  }
}
