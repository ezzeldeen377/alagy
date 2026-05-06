import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:alagy/core/common/screens/view_full_image.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';

class CustomProfilePicture extends StatelessWidget {
  const CustomProfilePicture({super.key});

  void _handleImageTap(BuildContext context, AddDoctorCubit cubit) {
    final hasImage = cubit.state.selectedProfilePicture != null ||
        cubit.state.doctor?.profileImage != null;
    if (!hasImage) return;

    final imageUrl = cubit.state.selectedProfilePicture != null
        ? cubit.state.selectedProfilePicture!.path
        : cubit.state.doctor!.profileImage!;

    context.push(ViewFullImage(
      imageUrl: imageUrl,
      tag: 'profile_picture',
    ));
  }

  ImageProvider? _getBackgroundImage(AddDoctorCubit cubit) {
    if (cubit.state.selectedProfilePicture != null) {
      return FileImage(cubit.state.selectedProfilePicture!);
    }
    if (cubit.state.doctor?.profileImage != null) {
      return NetworkImage(cubit.state.doctor!.profileImage!);
    }
    return null;
  }

  bool _shouldShowDefaultIcon(AddDoctorCubit cubit) {
    return cubit.state.selectedProfilePicture == null &&
        cubit.state.doctor?.profileImage == null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AddDoctorCubit>();

    return Stack(
      children: [
        GestureDetector(
          onTap: () => _handleImageTap(context, cubit),
          child: Hero(
            tag: 'profile_picture',
            child: CircleAvatar(
              radius: 70.r,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _getBackgroundImage(cubit),
              child: _shouldShowDefaultIcon(cubit)
                  ? Icon(Icons.person, size: 70.r, color: Colors.white)
                  : null,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showImagePickerBottomSheet(context, cubit),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColor.primaryColor,
              child: Icon(Icons.camera_alt, color: Colors.white, size: 18.r),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerBottomSheet(
      BuildContext context, AddDoctorCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.selectProfilePhoto,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
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
                    cubit.pickPofilePicture(ImageSource.camera);
                  },
                ),
                _buildImagePickerOption(
                  context,
                  icon: Icons.photo_library,
                  label: context.l10n.gallery,
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickPofilePicture(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30.sp,
              color: AppColor.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
