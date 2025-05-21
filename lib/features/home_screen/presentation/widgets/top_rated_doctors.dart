import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopRatedDoctors extends StatelessWidget {
  const TopRatedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    const List<TopDoctorModel> doctors = [
      TopDoctorModel(
        name: "Dr. Sarah Johnson",
        specialty: "Cardiologist",
        rating: 4.9,
        reviewCount: 124,
        imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
        isAvailable: true,
      ),
      TopDoctorModel(
        name: "Dr. Michael Chen",
        specialty: "Neurologist",
        rating: 4.8,
        reviewCount: 98,
        imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
        isAvailable: true,
      ),
      TopDoctorModel(
        name: "Dr. Aisha Rahman",
        specialty: "Pediatrician",
        rating: 4.7,
        reviewCount: 156,
        imageUrl: "https://randomuser.me/api/portraits/women/65.jpg",
        isAvailable: false,
      ),
      TopDoctorModel(
        name: "Dr. James Wilson",
        specialty: "Dermatologist",
        rating: 4.6,
        reviewCount: 87,
        imageUrl: "https://randomuser.me/api/portraits/men/52.jpg",
        isAvailable: true,
      ),
      TopDoctorModel(
        name: "Dr. Maria Garcia",
        specialty: "Orthopedic Surgeon",
        rating: 4.9,
        reviewCount: 142,
        imageUrl: "https://randomuser.me/api/portraits/women/28.jpg",
        isAvailable: false,
      ),
    ];

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
                  context.l10n.seeAll ,
                  style: const TextStyle(
                    color: AppColor.tealNew,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return TopDoctorCard(doctor: doctors[index]);
            },
          ),
        ],
      ),
    );
  }
}

class TopDoctorCard extends StatelessWidget {
  final TopDoctorModel doctor;

  const TopDoctorCard({
    super.key,
    required this.doctor,
  });
@override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Consistent margin for better spacing
      elevation: 4, // Slightly higher elevation for depth
      shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow for a modern look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r), // Softer corners
      ),
      child: InkWell(
        onTap: () {
          // Navigate to doctor details
        },
        borderRadius: BorderRadius.circular(16.r),
        splashColor: Colors.teal.withOpacity(0.2), // Subtle splash effect
        highlightColor: Colors.teal.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16.r), // Increased padding for a more spacious feel
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Doctor image with modern styling
              Hero(
                tag: 'doctor-image-${doctor.name}', // Hero animation for smooth transitions
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: _buildDoctorImage(doctor.imageUrl),
                  ),
                ),
              ),
              SizedBox(width: 16.w), // Increased spacing for better separation
              // Doctor info with improved hierarchy
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
                            color: Colors.grey[600], // Softer grey for better contrast
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
        border: Border.all(color: Colors.grey[200]!, width: 1), // Subtle border for polish
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

  Widget _buildAvailabilityBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: doctor.isAvailable
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: doctor.isAvailable ? Colors.green[300]! : Colors.red[300]!, // Subtle border
          width: 1,
        ),
      ),
      child: Text(
        doctor.isAvailable
            ? context.l10n.available ?? 'Available'
            : context.l10n.unavailable ?? 'Unavailable',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: doctor.isAvailable ? Colors.green[800] : Colors.red[800],
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
      ),
    );
  }

  Widget _buildRatingWidget(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded, // Rounded star for a modern look
          color: Colors.amber[400],
          size: 20.sp,
        ),
        SizedBox(width: 3.w),
        Text(
          doctor.rating.toStringAsFixed(1), // Show one decimal for precision
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: doctor.isAvailable
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: doctor.isAvailable ? Colors.green[300]! : Colors.red[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            doctor.isAvailable ? Icons.check_circle : Icons.cancel,
            color: doctor.isAvailable ? Colors.green[700] : Colors.red[700],
            size: 16.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            doctor.isAvailable
                ? context.l10n.available ?? 'Available'
                : context.l10n.unavailable ?? 'Unavailable',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: doctor.isAvailable ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
          ),
        ],
      ),
    );
  }
}

class TopDoctorModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final bool isAvailable;

  const TopDoctorModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.isAvailable,
  });
}