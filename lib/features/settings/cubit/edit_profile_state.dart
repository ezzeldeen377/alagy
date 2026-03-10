// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alagy/core/common/enities/user_model.dart';
import 'dart:io';

enum EditProfileStatus {
  initial,
  loading,
  success,
  error,
  imagePickerLoading,
  imagePickerSuccess,
  imagePickerError,
  uploadingImage,
  imageUploadSuccess,
  imageUploadError,
}

extension EditProfileStateX on EditProfileState {
  bool get isInitial => status == EditProfileStatus.initial;
  bool get isLoading => status == EditProfileStatus.loading;
  bool get isSuccess => status == EditProfileStatus.success;
  bool get isError => status == EditProfileStatus.error;
  bool get isImagePickerLoading => status == EditProfileStatus.imagePickerLoading;
  bool get isImagePickerSuccess => status == EditProfileStatus.imagePickerSuccess;
  bool get isImagePickerError => status == EditProfileStatus.imagePickerError;
  bool get isUploadingImage => status == EditProfileStatus.uploadingImage;
  bool get isImageUploadSuccess => status == EditProfileStatus.imageUploadSuccess;
  bool get isImageUploadError => status == EditProfileStatus.imageUploadError;
}

class EditProfileState {
  final EditProfileStatus status;
  final UserModel? user;
  final String? errorMessage;
  final File? selectedImage;
  final String? uploadedImageUrl;
  final bool isFormValid;
  final Map<String, String> fieldErrors;

  EditProfileState({
    required this.status,
    this.user,
    this.errorMessage,
    this.selectedImage,
    this.uploadedImageUrl,
    this.isFormValid = false,
    this.fieldErrors = const {},
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserModel? user,
    String? errorMessage,
    File? selectedImage,
    String? uploadedImageUrl,
    bool? isFormValid,
    Map<String, String>? fieldErrors,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedImage: selectedImage ?? this.selectedImage,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      isFormValid: isFormValid ?? this.isFormValid,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  String toString() {
    return 'EditProfileState(status: $status, user: $user, errorMessage: $errorMessage, selectedImage: $selectedImage, uploadedImageUrl: $uploadedImageUrl, isFormValid: $isFormValid, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(covariant EditProfileState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage &&
        other.selectedImage == selectedImage &&
        other.uploadedImageUrl == uploadedImageUrl &&
        other.isFormValid == isFormValid &&
        other.fieldErrors == fieldErrors;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        user.hashCode ^
        errorMessage.hashCode ^
        selectedImage.hashCode ^
        uploadedImageUrl.hashCode ^
        isFormValid.hashCode ^
        fieldErrors.hashCode;
  }
}