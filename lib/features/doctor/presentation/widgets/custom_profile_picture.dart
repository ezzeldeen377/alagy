import 'package:alagy/core/common/screens/view_full_image.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/features/doctor/presentation/bloc/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            onTap: () => cubit.pickPofilePicture(),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.teal,
              child: Icon(Icons.camera_alt, color: Colors.white, size: 18.r),
            ),
          ),
        ),
      ],
    );
  }
}
