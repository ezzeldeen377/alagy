import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/models/doctor_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Removed CachedNetworkImage import as it's now in top_doctor_card.dart

// Imports for separated classes
import './top_doctor_card.dart';

class TopRatedDoctors extends StatelessWidget {
  const TopRatedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
     List<DoctorModel> doctors =context.read<HomeScreenCubit>().state.topRateddoctors??[];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.topRatedDoctors,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all doctors page
                },
                child: Text(
                  context.l10n.seeAll,
                  style: const TextStyle(
                    color: AppColor.tealNew,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return TopDoctorCard(doctor: doctor,);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Removed TopDoctorCard class
// Removed TopDoctorModel class
