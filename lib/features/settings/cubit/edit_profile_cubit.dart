import 'dart:io';
import 'package:alagy/features/doctor_details/data/repositories/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/features/authentication/data/repositories/auth_repository.dart';
import 'edit_profile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final AuthRepository _authRepository;
  final AppUserCubit _appUserCubit;
  final DoctorRepository _doctorRepository;
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditProfileCubit(
    this._doctorRepository, {
    required AuthRepository authRepository,
    required AppUserCubit appUserCubit,
  })  : _authRepository = authRepository,
        _appUserCubit = appUserCubit,
        super(EditProfileState(status: EditProfileStatus.initial));

  void initializeProfile(UserModel user) {
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phoneNumber ?? '';
    cityController.text = user.city ?? '';

    emit(state.copyWith(
      status: EditProfileStatus.initial,
      user: user,
    ));
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.imagePickerLoading));

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        emit(state.copyWith(
          status: EditProfileStatus.imagePickerSuccess,
          selectedImage: imageFile,
        ));
      } else {
        emit(state.copyWith(status: EditProfileStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.imagePickerError,
        errorMessage: 'Failed to pick image: ${e.toString()}',
      ));
    }
  }

  Future<String?> _uploadImage(File imageFile, String userId) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.uploadingImage));

      final response = await _doctorRepository.uploadProfilePicture(imageFile);
      response.fold(
          (l) => emit(state.copyWith(
              status: EditProfileStatus.imageUploadError,
              errorMessage: l.message)),
          (r) {
            emit(state.copyWith(status: EditProfileStatus.imageUploadSuccess));
            return r;
          });
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.imageUploadError,
        errorMessage: 'Failed to upload image: ${e.toString()}',
      ));
      return null;
    }
  }

  void validateForm() {
    final Map<String, String> errors = {};

    if (nameController.text.trim().isEmpty) {
      errors['name'] = 'Name is required';
    } else if (nameController.text.trim().length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    }

    if (emailController.text.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      errors['email'] = 'Please enter a valid email';
    }

    if (phoneController.text.trim().isNotEmpty) {
      if (!RegExp(r'^[+]?[0-9]{10,15}$')
          .hasMatch(phoneController.text.trim())) {
        errors['phone'] = 'Please enter a valid phone number';
      }
    }

    final bool isValid = errors.isEmpty;

    emit(state.copyWith(
      fieldErrors: errors,
      isFormValid: isValid,
    ));
  }

  Future<void> updateProfile() async {
    if (!state.isFormValid) {
      validateForm();
      return;
    }

    try {
      emit(state.copyWith(status: EditProfileStatus.loading));

      String? imageUrl = state.user?.profileImage;

      // Upload new image if selected
      if (state.selectedImage != null) {
        final uploadedUrl =
            await _uploadImage(state.selectedImage!, state.user!.uid);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        } else {
          // If image upload failed, don't proceed with profile update
          return;
        }
      }

      // Prepare update data
      final Map<String, dynamic> updateData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'city': cityController.text.trim().isEmpty
            ? null
            : cityController.text.trim(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      if (imageUrl != state.user?.profileImage) {
        updateData['profileImage'] = imageUrl;
      }

      // Update user in Firestore
      final result =
          await _authRepository.updateUser(state.user!.uid, updateData);

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: EditProfileStatus.error,
            errorMessage: failure.message,
          ));
        },
        (_) {
          // Create updated user model
          final updatedUser = state.user!.copyWith(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim().isEmpty
                ? null
                : phoneController.text.trim(),
            city: cityController.text.trim().isEmpty
                ? null
                : cityController.text.trim(),
            profileImage: imageUrl,
            updatedAt: DateTime.now(),
          );

          // Update app user state
          _appUserCubit.updateUser(updatedUser, updateData);

          emit(state.copyWith(
            status: EditProfileStatus.success,
            user: updatedUser,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.error,
        errorMessage: 'Failed to update profile: ${e.toString()}',
      ));
    }
  }

  void clearSelectedImage() {
    emit(state.copyWith(
      selectedImage: null,
      status: EditProfileStatus.initial,
    ));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    return super.close();
  }
}
