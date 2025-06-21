import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctors_cubit.dart';
import 'package:alagy/features/doctor/presentation/widgets/category_doctor_card.dart';
import 'package:alagy/features/home_screen/presentation/bloc/bookmark/cubit/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookmark History",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor,
              ),
        ),
        elevation: 4,
        foregroundColor: AppColor.whiteColor, // For text and icons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
        ),
      ),
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
                    'Error loading doctors',
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
                    child: const Text('Retry'),
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
                    Icons.medical_services_outlined,
                    color: AppColor.greyColor,
                    size: 48.r,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No doctors available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColor.blackColor,
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