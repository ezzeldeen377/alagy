import 'dart:io';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/theme/app_color.dart';
import '../cubit/edit_profile_cubit.dart';
import '../cubit/edit_profile_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentAmber = Color(0xFFC107);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color cardWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => getIt<EditProfileCubit>()
        ..initializeProfile(context.read<AppUserCubit>().state.user!),
      child: BlocConsumer<AppUserCubit, AppUserState>(
        listener: (context, appUserState) {
          if (appUserState.user != null) {
            context
                .read<EditProfileCubit>()
                .initializeProfile(appUserState.user!);
          }
        },
        builder: (context, appUserState) {
          if (appUserState.user == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: primaryBlue),
              ),
            );
          }

          return Scaffold(
            backgroundColor: isDarkMode ? const Color(0xFF121212) : lightGrey,
            appBar: _buildAppBar(context, isDarkMode),
            body: BlocConsumer<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  showSnackBar(
                      context, context.l10n.profileUpdatedSuccessfully);

                  Navigator.of(context).pop();
                } else if (state.isError) {
                  showSnackBar(
                      context, state.errorMessage ?? context.l10n.anErrorOccurred,
                      backgroundColor: Colors.red);
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Form(
                      key: context.read<EditProfileCubit>().formKey,
                      child: Column(
                        children: [
                          // Profile Image Section
                          _buildProfileImageSection(context, state, isDarkMode),
                          SizedBox(height: 30.h),

                          // Form Fields
                          _buildFormFields(context, state, isDarkMode),
                          SizedBox(height: 30.h),

                          // Save Button
                          _buildSaveButton(context, state, isDarkMode),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : Colors.black87,
          size: 20.sp,
        ),
      ),
      title: Text(
        context.l10n.editProfile,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
          fontFamily: 'Inter',
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileImageSection(
      BuildContext context, EditProfileState state, bool isDarkMode) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: _buildProfileImage(state),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImagePickerBottomSheet(context),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isDarkMode ? const Color(0xFF121212) : Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
            if (state.isUploadingImage)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage(EditProfileState state) {
    if (state.selectedImage != null) {
      return Image.file(
        state.selectedImage!,
        fit: BoxFit.cover,
      );
    } else if (state.user?.profileImage != null) {
      return CachedNetworkImage(
        imageUrl: state.user!.profileImage!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: lightGrey,
          child: const Center(
            child: CircularProgressIndicator(color: primaryBlue),
          ),
        ),
        errorWidget: (context, url, error) =>
            _buildDefaultAvatar(state.user?.name ?? 'U'),
      );
    } else {
      return _buildDefaultAvatar(state.user?.name ?? 'U');
    }
  }

  Widget _buildDefaultAvatar(String name) {
    return Image.network(
      "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormFields(
      BuildContext context, EditProfileState state, bool isDarkMode) {
    final cubit = context.read<EditProfileCubit>();

    return Column(
      children: [
        _buildTextField(
          controller: cubit.nameController,
          label: context.l10n.fullName,
          icon: Icons.person_outline,
          isDarkMode: isDarkMode,
          errorText: state.fieldErrors['name'],
          onChanged: (_) => cubit.validateForm(),
        ),
        SizedBox(height: 20.h),
        _buildTextField(
          controller: cubit.emailController,
          label: context.l10n.email,
          readOnly: true,
          icon: Icons.email_outlined,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.emailAddress,
          errorText: state.fieldErrors['email'],
          onChanged: (_) => cubit.validateForm(),
        ),
        SizedBox(height: 20.h),
        _buildTextField(
          controller: cubit.phoneController,
          label: context.l10n.phoneNumberOptional,
          icon: Icons.phone_outlined,
          isDarkMode: isDarkMode,
          keyboardType: TextInputType.phone,
          errorText: state.fieldErrors['phone'],
          onChanged: (_) => cubit.validateForm(),
        ),
        SizedBox(height: 20.h),
        _buildTextField(
          controller: cubit.cityController,
          label: context.l10n.cityOptional,
          icon: Icons.location_city_outlined,
          isDarkMode: isDarkMode,
          errorText: state.fieldErrors['city'],
          onChanged: (_) => cubit.validateForm(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    bool? readOnly = false,
    String? errorText,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            readOnly: readOnly!,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                color: darkGrey,
                fontFamily: 'Inter',
              ),
              prefixIcon: Icon(
                icon,
                color: primaryBlue,
                size: 20.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              errorText,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(
      BuildContext context, EditProfileState state, bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: state.isFormValid
              ? [primaryBlue, primaryBlue.withOpacity(0.8)]
              : [darkGrey, darkGrey.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color:
                (state.isFormValid ? primaryBlue : darkGrey).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed:
            state.isFormValid && !state.isLoading && !state.isUploadingImage
                ? () => context.read<EditProfileCubit>().updateProfile()
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        child: state.isLoading || state.isUploadingImage
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.saveChanges,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<EditProfileCubit>(),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: darkGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                context.l10n.selectProfilePhoto,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePickerOption(
                    context,
                    icon: Icons.camera_alt,
                    label: context.l10n.camera,
                    onTap: () {
                      Navigator.pop(context);
                      context
                          .read<EditProfileCubit>()
                          .pickImage(ImageSource.camera);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  _buildImagePickerOption(
                    context,
                    icon: Icons.photo_library,
                    label: context.l10n.gallery,
                    onTap: () {
                      Navigator.pop(context);
                      context
                          .read<EditProfileCubit>()
                          .pickImage(ImageSource.gallery);
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30.sp,
              color: primaryBlue,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
