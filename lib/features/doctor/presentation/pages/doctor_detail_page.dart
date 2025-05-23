import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/doctor_sliver_app_bar.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/time_slot_chip.dart';
import 'package:alagy/features/doctor/presentation/widgets/section_header.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DoctorDetailPage extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with image carousel
          DoctorSliverAppBar(
            doctor: widget.doctor,
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.all(16.r),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Card with enhanced design
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
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
                                Text(
                                  widget.doctor.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                if (widget.doctor.specialization != null)
                                  Text(
                                    widget.doctor.specialization!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.black54,
                                        ),
                                  ),
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
                                      '4.5', // Placeholder rating - replace with actual rating
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '(120)', // Placeholder review count - replace with actual count
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),

                                // Enhanced experience badge
                                if (widget.doctor.yearsOfExperience != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: AppColor.tealNew.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color:
                                            AppColor.tealNew.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.workspace_premium,
                                          color: AppColor.tealNew,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${widget.doctor.yearsOfExperience}+ ',
                                                style: TextStyle(
                                                  color: AppColor.tealNew,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.l10n.yearsExp,
                                                style: TextStyle(
                                                  color: AppColor.tealNew,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Call button
                          if (widget.doctor.phoneNumber != null)
                            ActionButton(
                              icon: Icons.phone,
                              label: context.l10n.call,
                              color: Colors.green,
                              onTap: () async {
                                final Uri phoneUri = Uri(
                                  scheme: 'tel',
                                  path: widget.doctor.phoneNumber,
                                );
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                }
                              },
                            ),
                          // Email button
                          if (widget.doctor.email != null)
                            ActionButton(
                              icon: Icons.email,
                              label: context.l10n.email,
                              color: Colors.blue,
                              onTap: () async {
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: widget.doctor.email,
                                );
                                if (await canLaunchUrl(emailUri)) {
                                  await launchUrl(emailUri);
                                }
                              },
                            ),
                          // Book appointment button
                          ActionButton(
                            icon: Icons.calendar_today,
                            label: context.l10n.book,
                            color: AppColor.tealNew,
                            onTap: () {
                              // Implement booking functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      context.l10n.bookingFeatureComingSoon),
                                  backgroundColor: AppColor.tealNew,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Rest of the content remains the same
                // Consultation Fee - Highlighted section
                if (widget.doctor.consultationFee != null) ...[
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColor.tealNew.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border:
                          Border.all(color: AppColor.tealNew.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.payments_outlined,
                            color: AppColor.tealNew, size: 24.sp),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.consultationFee,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '\$${widget.doctor.consultationFee!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.tealNew,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // About section with bio
                if (widget.doctor.bio != null) ...[
                  SectionHeader(title: context.l10n.doctorDetailBio),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.doctor.bio!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // The rest of the sections remain the same...
                // Professional Info, Hospital/Clinic & Address, Contact Info, Availability Schedule, Map location
                SectionHeader(title: context.l10n.availabilitySchedule),
                Divider(),
                EasyDateTimeLinePicker(
                  firstDate: DateTime(2025, 1, 1),
                  lastDate: DateTime(2030, 3, 18),
                  focusedDate: DateTime(2025, 6, 15),
                  onDateChange: (date) {
                    // Handle the selected date, potentially updating available time slots
                    setState(() {
                      // You can update state here if you fetch time slots dynamically
                    });
                  },
                ),
// Available Time Slots
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.availableTimeSlots,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                      SizedBox(height: 8.h),
                      // Sample time slot (replace with dynamic data from backend)
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          TimeSlotChip(
                            time: '9:00 AM',
                            onTap: () {
                              // Handle time slot selection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected 9:00 AM'),
                                  backgroundColor: AppColor.tealNew,
                                ),
                              );
                            },
                          ),
                          TimeSlotChip(
                            time: '9:00 AM',
                            onTap: () {
                              // Handle time slot selection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected 9:00 AM'),
                                  backgroundColor: AppColor.tealNew,
                                ),
                              );
                            },
                          ),
                          TimeSlotChip(
                            time: '9:00 AM',
                            onTap: () {
                              // Handle time slot selection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected 9:00 AM'),
                                  backgroundColor: AppColor.tealNew,
                                ),
                              );
                            },
                          ),
                          TimeSlotChip(
                            time: '9:00 AM',
                            onTap: () {
                              // Handle time slot selection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected 9:00 AM'),
                                  backgroundColor: AppColor.tealNew,
                                ),
                              );
                            },
                          ),
                          // Add more time slots as needed
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

// Book appointment button (unchanged)
              
                // Book appointment button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement booking functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.bookingFeatureComingSoon),
                          backgroundColor: AppColor.tealNew,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.tealNew,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      context.l10n.bookAppointment,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ]),
            ),
          ),
        ],
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}

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
            Icon(icon, color: AppColor.tealNew, size: 20.sp),
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
                          color: isActionable ? AppColor.tealNew : null,
                          decoration:
                              isActionable ? TextDecoration.underline : null,
                        ),
                  ),
                ],
              ),
            ),
            if (isActionable)
              Icon(Icons.arrow_forward_ios,
                  size: 14.sp, color: AppColor.tealNew),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
