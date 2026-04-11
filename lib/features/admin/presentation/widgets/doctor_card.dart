import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool showActions;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onUpgradeToVip;
  final VoidCallback? onMoveToRejected;  // New callback
  final VoidCallback? onMoveToApproved;  // New callback

  const DoctorCard({
    super.key,
    required this.doctor,
    this.showActions = false,
    this.onApprove,
    this.onReject,
    this.onUpgradeToVip,
    this.onMoveToRejected,  // New parameter
    this.onMoveToApproved,  // New parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 30.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name ?? context.l10n.unknownDoctor,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doctor.email ?? context.l10n.noEmail,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (doctor.specialization != null) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            doctor.specialization ?? context.l10n.unknown,
                            style: context.theme.textTheme.bodySmall?.copyWith(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            
            if (doctor.bio != null && doctor.bio!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                context.l10n.bio,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                doctor.bio??"",
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ],

            if (doctor.yearsOfExperience != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${doctor.yearsOfExperience} ${context.l10n.yearsExperience}',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],

            if (doctor.phoneNumber != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    doctor.phoneNumber??"",
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],

            if (showActions) ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onReject,
                      icon: Icon(
                        Icons.close,
                        size: 18.sp,
                      ),
                      label: Text(context.l10n.reject),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: Icon(
                        Icons.check,
                        size: 18.sp,
                      ),
                      label: Text(context.l10n.approve),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (doctor.isAccepted == true) ...[
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onUpgradeToVip,
                  icon: Icon(
                    doctor.isVip == true ? Icons.remove_circle : Icons.workspace_premium,
                    size: 18.sp,
                  ),
                  label: Text(doctor.isVip == true ? context.l10n.removeVip : context.l10n.upgradeToVip),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: doctor.isVip == true ? Colors.red : Colors.amber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              // Add button to move approved doctor to rejected
              if (onMoveToRejected != null) ...[
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onMoveToRejected,
                    icon: Icon(
                      Icons.block,
                      size: 18.sp,
                    ),
                    label: Text(context.l10n.moveToRejected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ],
            // Add button to move rejected doctor to approved
            if (doctor.isAccepted == false && onMoveToApproved != null) ...[
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onMoveToApproved,
                  icon: Icon(
                    Icons.check_circle,
                    size: 18.sp,
                  ),
                  label: Text(context.l10n.moveToApproved),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}