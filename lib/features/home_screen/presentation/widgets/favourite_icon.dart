import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FavoriteIcon extends StatelessWidget {
  final DoctorModel doctor;
  final bool fromDetailsScreen;

  const FavoriteIcon({
    super.key,
    required this.doctor,  this.fromDetailsScreen=false,
  });

  @override
  Widget build(BuildContext context) {
    final userFavouriteIds =context.watch<AppUserCubit>().state.favouriteIds;
    bool isFavorite = userFavouriteIds!.contains(doctor.uid);
    return IconButton(
      style:fromDetailsScreen?null: IconButton.styleFrom(backgroundColor:context.theme.scaffoldBackgroundColor),
      icon: SvgPicture.asset(
        isFavorite ?"assets/icons/love_icon_filled.svg"  :"assets/icons/love_icon.svg",
        
      ),
      onPressed: () {
        if (isFavorite) {
          context.read<AppUserCubit>().removeDoctorFromFavourite(doctor,context.read<AppUserCubit>().state.userId!);
        } else {
          print("add");
          context.read<AppUserCubit>().addDoctorToFavourite(doctor,context.read<AppUserCubit>().state.userId!);
        }
      },
      padding: EdgeInsets.all(4.r),
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}