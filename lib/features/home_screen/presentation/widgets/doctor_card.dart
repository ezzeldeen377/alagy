import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isActive;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isActive ? 1.0 : 0.95),
            margin: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: isActive ? 0 : 8.h,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.isDark ? Colors.grey : Colors.white,
                  AppColor.tealNew.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isActive
                    ? AppColor.tealNew.withOpacity(0.4)
                    : Colors.transparent,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isActive ? 0.2 : 0.1),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Doctor image
                    Hero(
                      tag: 'doctor_image_${doctor.name}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: SizedBox(
                          width: 100.w,
                          height: 150.h,
                          child: doctor.profileImage!=null
                              ? CachedNetworkImage(
                                  imageUrl: doctor.profileImage!,
                                  fit: BoxFit.cover,
                                  memCacheHeight: (100.h *
                                          MediaQuery.of(context)
                                              .devicePixelRatio)
                                      .round(),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      _buildFallbackImage(),
                                )
                              : SizedBox(
                                  width: 100.w,
                                  height: 150.h,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Doctor info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            doctor.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  fontSize: 16.sp,
                                  letterSpacing: 0.3,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            semanticsLabel: doctor.name,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                          context.getSpecialty(doctor.specialization??'')  ,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black54,
                                      fontSize: 14.sp,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber.shade700,
                                size: 18.sp,
                                semanticLabel: 'Rating',
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                doctor.rating?.toStringAsFixed(1)??'0',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      fontSize: 12.sp,
                                    ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "(${doctor.reviews.length} reviews)",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black45,
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton.icon(
                            // Changed to ElevatedButton.icon
                            onPressed: onTap,
                            icon: Icon(Icons.calendar_today_outlined,
                                size: 14.sp), // Added icon
                            label: Text(
                              context.l10n.bookNow,
                              semanticsLabel: context.l10n.bookNow,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.tealNew,
                              foregroundColor:
                                  Colors.white, // Affects both icon and text
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 5.h), // Adjusted vertical padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.r), // Softer corners
                              ),
                              elevation: 4, // Slightly increased elevation
                              shadowColor: AppColor.tealNew.withOpacity(
                                  0.35), // Slightly more defined shadow
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.w600, // Adjusted font weight
                                    fontSize:
                                        12.sp, // Slightly adjusted font size
                                    letterSpacing:
                                        0.3, // Added subtle letter spacing
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // Use Positioned for more precise control within Stack
            top: 0,
            right: context.isRtl ? null : 8.w,
            left: context.isRtl ? 8.w : null,
            child: Container(
              height: 30.h,
              width: 50.w,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    AppColor.gold, // Assuming you have a gold color in AppColor
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(context.isRtl?0:16.r),
                    topRight: Radius.circular(context.isRtl?0:16.r),
                    topLeft: Radius.circular(context.isRtl?16.r:0),
                    bottomRight: Radius.circular(context.isRtl?16.r:0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                "VIP",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.tealNew.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 48.sp,
          color: AppColor.tealNew.withOpacity(0.7),
          semanticLabel: 'Doctor placeholder',
        ),
      ),
    );
  }
}
