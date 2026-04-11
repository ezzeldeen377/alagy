import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home/home_screen_state.dart';
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
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        final doctors = state.topRateddoctors ?? [];
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.topRatedDoctors,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(RouteNames.doctorPage);
                    },
                    child: Text(
                      context.l10n.seeAll,
                      style: const TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ListView.separated(
                itemCount: doctors.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return TopDoctorCard(doctor: doctor);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Removed TopDoctorCard class
// Removed TopDoctorModel class
