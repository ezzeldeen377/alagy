import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/widgets/favourite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const CategoryDoctorCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          context.pushNamed(RouteNames.doctorDetails, arguments: doctor);
        },
        child: Card(
          elevation: 4,
          shadowColor:context.isDark? Colors.black26:Colors.white10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(
              color:context.isDark? Colors.grey.shade700: Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    Hero(
                      tag: 'horizontal_doctor_image_${doctor.name}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            doctor.profileImage ?? '',
                            height: 90.h,
                            width: 90.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 90.h,
                                width: 90.w,
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: 40.r,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  doctor.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.medical_services_outlined,
                                size: 14.r,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  context.getSpecialty(doctor.specialization ?? ''),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                doctor.rating?.toStringAsFixed(1) ?? '0',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(${doctor.reviews.length})',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                size: 14.r,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${doctor.consultationFee ?? 0} EGP',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.r,
                right: context.isRtl ? null : 0.r,
                left: context.isRtl ? 0.r : null,
                child: FavoriteIcon(
                  doctor: doctor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}