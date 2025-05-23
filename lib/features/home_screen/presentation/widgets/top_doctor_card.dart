import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:alagy/features/home_screen/presentation/models/doctor_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopDoctorCard extends StatelessWidget {
  final DoctorCardModel doctor;

  const TopDoctorCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 8
              .w, // Keep original horizontal margin if it's for the card itself within the list
          vertical: 8.h),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: () {
  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailPage(
                        doctor: DoctorModel(
                            uid: '12345',
                            name: "Dr. Sarah Johnson",
                            email: "gfdgdfgdf",
                            phoneNumber: "0123456789",address: "gfdgdfgdf",
                            specialization: "Cardiologist",
                            yearsOfExperience: 10,
                            city: "gfdgdfgdf",
                            consultationFee: 100,
                            qualification: "gfdgdfgdf",
                            hospitalName: "gfdgdfgdf",

                            bio: " gfdgdfgdf fsdfsfd asdfasdasf dafsd fsdffsdfs s fdsdfdsf s dffsdfsq er fweewtw sdfsdfs xcsdfsdfsdfs asdlmkl;fnw wdfkdf ",
                            createdAt: DateTime.now(),
                            profileImage:doctor.imageUrl
                                ,)),
                  ),
                );
        },
        borderRadius: BorderRadius.circular(16.r),
        splashColor: Colors.teal.withOpacity(0.2),
        highlightColor: Colors.teal.withOpacity(0.1),
        child: Padding(
          // Added Padding here as it was missing in the original structure for TopDoctorCard's direct child
          padding: EdgeInsets.all(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'doctor-image-${doctor.name}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: _buildDoctorImage(doctor.imageUrl),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            letterSpacing: 0.2,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      doctor.specialty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRatingWidget(context),
                        _buildAvailabilityIndicator(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: imageUrl.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.tealNew,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                  size: 40.sp,
                ),
              ),
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                  size: 40.sp,
                ),
              ),
            ),
    );
  }

  Widget _buildRatingWidget(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: Colors.amber[400],
          size: 20.sp,
        ),
        SizedBox(width: 3.w),
        Text(
          doctor.rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(width: 6.w),
        Text(
          "(${doctor.reviewCount})",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.green.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        // Keep the Row to include the status icon if you decide to add it back
        mainAxisSize: MainAxisSize.min,
        children: [
          // Optional: Add status icon back if needed
          // Icon(
          //   doctor.isAvailable ? Icons.check_circle_outline_rounded : Icons.highlight_off_rounded,
          //   color: statusColor,
          //   size: 18.sp,
          // ),
          // SizedBox(width: doctor.isAvailable ? 6.w : 0), // Conditional spacing
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.green,
            size: 14.sp,
          ),
        ],
      ),
    );
  }
}
