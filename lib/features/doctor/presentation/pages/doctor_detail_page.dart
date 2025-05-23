import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';

class DoctorDetailPage extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: AppColor.tealNew,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      width: 90.w,
                      height: 90.w,
                      child: doctor.profileImage != null
                          ? CachedNetworkImage(
                              imageUrl: doctor.profileImage!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColor.tealNew.withOpacity(0.1),
                                child: const Icon(Icons.person_rounded, size: 60),
                              ),
                            )
                          : Container(
                              color: AppColor.tealNew.withOpacity(0.1),
                              child: const Icon(Icons.person_rounded, size: 60),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          doctor.specialization ?? '',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 20.sp),
                            SizedBox(width: 4.w),
                          
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Contact Info
            if (doctor.phoneNumber != null || doctor.email != null || doctor.city != null) ...[
              SectionHeader(title: context.l10n.doctorDetailContactInfo),
              Divider(),
              if (doctor.phoneNumber != null)
                DetailRow(icon: Icons.phone, label: context.l10n.phoneNumber, value: doctor.phoneNumber!),
              if (doctor.email != null)
                DetailRow(icon: Icons.email, label: context.l10n.email, value: doctor.email!),
              if (doctor.city != null)
                DetailRow(icon: Icons.location_city, label: context.l10n.city, value: doctor.city!),
              SizedBox(height: 16.h),
            ],
            // Professional Info
            if (doctor.qualification != null || doctor.licenseNumber != null || doctor.yearsOfExperience != null || doctor.consultationFee != null) ...[
              SectionHeader(title: context.l10n.doctorDetailProfessionalInfo),
              Divider(),
              if (doctor.qualification != null)
                DetailRow(icon: Icons.school, label: context.l10n.qualification, value: doctor.qualification!),
              if (doctor.licenseNumber != null)
                DetailRow(icon: Icons.assignment, label: context.l10n.licenseNumber, value: doctor.licenseNumber!),
              if (doctor.yearsOfExperience != null)
                DetailRow(icon: Icons.timeline, label: context.l10n.yearsOfExperience, value: '${doctor.yearsOfExperience} years'),
              if (doctor.consultationFee != null)
                DetailRow(icon: Icons.attach_money, label: context.l10n.consultationFee, value: '\$${doctor.consultationFee?.toStringAsFixed(2)}'),
              SizedBox(height: 16.h),
            ],
            // Hospital/Clinic
            if (doctor.hospitalName != null) ...[
              SectionHeader(title: context.l10n.doctorDetailHospital),
              Divider(),
              DetailRow(icon: Icons.local_hospital, label: context.l10n.hospitalOrClinic, value: doctor.hospitalName!),
              SizedBox(height: 16.h),
            ],
            // Location
            if (doctor.latitude != null && doctor.longitude != null) ...[
              SectionHeader(title: context.l10n.doctorDetailLocation),
              Divider(),
              DetailRow(
                icon: Icons.location_on,
                label: context.l10n.coordinates,
                value: 'Lat: ${doctor.latitude?.toStringAsFixed(4)}, Lon: ${doctor.longitude?.toStringAsFixed(4)}',
              ),
              SizedBox(height: 16.h),
            ],
            // Bio
            if (doctor.bio != null) ...[
              SectionHeader(title: context.l10n.doctorDetailBio),
              Divider(),
              Text(
                doctor.bio!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16.h),
            ],
            // Availability
            if (doctor.openDurations != null && doctor.openDurations!.isNotEmpty) ...[
              SectionHeader(title: context.l10n.doctorDetailAvailability),
              Divider(),
              ...doctor.openDurations!.map((duration) {
                final dayName = context.getDayOfWeek(duration.day ?? '');
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18.sp, color: duration.isClosed == true ? Colors.red : AppColor.tealNew),
                      SizedBox(width: 8.w),
                      Text(
                        dayName,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8.w),
                      if (duration.isClosed == true)
                        Chip(
                          label: Text(context.l10n.closed, style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.redAccent,
                        )
                      else
                        Chip(
                          label: Text('${duration.startTime ?? '--'} - ${duration.endTime ?? '--'}'),
                          backgroundColor: AppColor.tealNew.withOpacity(0.1),
                        ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 16.h),
            ],
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const DetailRow({super.key, required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.tealNew, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}