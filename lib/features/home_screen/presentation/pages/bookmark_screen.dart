import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctor_state.dart';
import 'package:alagy/features/doctor_details/presentation/bloc/doctors_cubit.dart';
import 'package:alagy/features/doctor_details/presentation/widgets/category_doctor_card.dart';
import 'package:alagy/features/home_screen/presentation/bloc/bookmark/cubit/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            );
          } else if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColor.redColor,
                    size: 48.r,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.errorLoadingDoctors,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColor.blackColor,
                        ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DoctorsCubit>().getDoctors(context.watch<DoctorsCubit>().state.category??"");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    child:  Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          } else if ( state.bookmarkDoctors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    color: AppColor.greyColor,
                    size: 64.r,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.noBookmarkedDoctorsYet,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.startBookmarkingDoctorsToSeeThemHere,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.greyColor,
                        ),
                  ),
                ],
              ),
            );
          } else {
            return _buildDoctorList(state.bookmarkDoctors);
          }
        },
      ),
    );
  }

  Widget _buildDoctorList(List<DoctorModel> doctors) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: CategoryDoctorCard(doctor: doctors[index]),
        );
      },
    );
  }
  
}