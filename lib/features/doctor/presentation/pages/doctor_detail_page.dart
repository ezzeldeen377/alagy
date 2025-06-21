import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/actionButton.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/booking_tab.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/doctor_sliver_app_bar.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/review_tab.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/tab_bar_section.dart';
import 'package:alagy/features/doctor/presentation/widgets/section_header.dart';
import 'package:alagy/features/map/presentation/screens/show_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';

class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorDetailsCubit>().state.selectedDoctor;
    return Scaffold(
      body: CustomScrollView(
        controller: context.read<DoctorDetailsCubit>().scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SliverAppBar with image carousel
          DoctorSliverAppBar(
            doctor: doctor!,
          ),
          // Content
          SliverPadding(
            padding: EdgeInsets.all(16.r),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                // Profile Card with enhanced design
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.isDark
                            ? Colors.black12.withAlpha(100)
                            : Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Doctor basic info - now without the image since it's in the SliverAppBar
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (doctor.specialization != null)
                                  Text(doctor.specialization!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                SizedBox(height: 8.h),

                                // Rating component
                                Row(
                                  children: [
                                    // Star rating (using a placeholder value of 4.5 - you can replace with actual rating)
                                    Row(
                                      children: List.generate(5, (index) {
                                        // Full stars for index < 4, half star for index = 4 (for 4.5 rating)
                                        return Icon(
                                          index < 4
                                              ? Icons.star
                                              : Icons.star_half,
                                          color: Colors.amber,
                                          size: 18.sp,
                                        );
                                      }),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      doctor.rating?.toStringAsFixed(1)??"0"  , // Placeholder rating - replace with actual rating
                                        style:
                                            context.theme.textTheme.bodyMedium),
                                    SizedBox(width: 4.w),
                                    Text(
                                        '(${doctor.reviews.length})', // Placeholder review count - replace with actual count
                                        style:
                                            context.theme.textTheme.bodyMedium),
                                  ],
                                ),
                                SizedBox(height: 12.h),

                                // Enhanced experience badge
                                if (doctor.yearsOfExperience != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 6.h),
                                   
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.workspace_premium,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${doctor.yearsOfExperience}+ ',
                                                style: TextStyle(
                                                  color: AppColor.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.l10n.yearsExp,
                                                style: TextStyle(
                                                  color: AppColor.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Quick action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Call button

                          // Book appointment button
                          ActionButton(
                            icon: Icons.calendar_today,
                            label: context.l10n.book,
                            color: AppColor.primaryColor,
                            onTap: () {
                              // Implement booking functionality
                             if (context.read<DoctorDetailsCubit>().targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        context.read<DoctorDetailsCubit>().targetKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0, // 0.0 = top, 1.0 = bottom
      );
    }
                            },
                          ),
                          if (doctor.latitude != null &&
                              doctor.longitude != null)
                            ActionButton(
                              icon: Icons.route,
                              label: context.l10n.viewOnMap,
                              color: Colors.blue,
                              onTap: () async {
                                context.push(ShowLocationScreen(
                                  lat: doctor.latitude ?? 30.0444,
                                  lng: doctor.longitude ?? 31.2357,
                                ));
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Consultation Fee
                if (doctor.consultationFee != null) ...[
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    
                    child: Row(
                      children: [
                        Icon(Icons.payments_outlined,
                          size: 24.sp),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.consultationFee,
                                style: context.theme.textTheme.bodyMedium),
                            Text(
                              'EGP ${doctor.consultationFee!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
                // About Section
                if (doctor.bio != null) ...[
                  SectionHeader(title: context.l10n.doctorDetailBio),
                  const Divider(),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: context.isDark
                              ? Colors.black12.withAlpha(100)
                              : Colors.black12,
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      doctor.bio!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    key: context.read<DoctorDetailsCubit>().targetKey,
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: const TabBarSection(),
                  )
                 
                ],
              ]),
            ),
          ),
          // TabBar
        ],
      ),
    );
  }
}

// Review Item Widget

// New SliverAppBar widget for the doctor detail page

// Keep the existing DetailRow and ActionButton widgets
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isActionable;
  final VoidCallback? onTap;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isActionable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: InkWell(
        onTap: isActionable ? onTap : null,
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isActionable ? AppColor.primaryColor : null,
                          decoration:
                              isActionable ? TextDecoration.underline : null,
                        ),
                  ),
                ],
              ),
            ),
            if (isActionable)
              Icon(Icons.arrow_forward_ios,
                  size: 14.sp,),
          ],
        ),
      ),
    );
  }
}
