import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FavoriteIcon extends StatelessWidget {
  final DoctorModel doctor;
  final bool fromDetailsScreen;

  const FavoriteIcon({
    super.key,
    required this.doctor,
    this.fromDetailsScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppUserCubit>();
    final userId = context.read<AppUserCubit>().state.user?.uid ?? "";
    final userFavouriteIds = context.watch<AppUserCubit>().state.favouriteIds;
    bool isFavorite = userFavouriteIds!.contains(doctor.uid);
    return IconButton(
      style: fromDetailsScreen
          ? null
          : IconButton.styleFrom(
              backgroundColor: context.theme.scaffoldBackgroundColor),
      icon: SvgPicture.asset(
        isFavorite
            ? "assets/icons/love_icon_filled.svg"
            : fromDetailsScreen?"assets/icons/love_icon_white.svg": "assets/icons/love_icon.svg",
      ),
      onPressed: () {
        if (cubit.state.isNotLogin) {
          showLoginDialog(context);
          return;
        }
        if (isFavorite) {
          cubit.removeDoctorFromFavourite(doctor, userId);
        } else {
          print("add");
          cubit.addDoctorToFavourite(doctor, userId);
        }
      },
      padding: EdgeInsets.all(4.r),
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
