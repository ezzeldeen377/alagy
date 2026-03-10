import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/core/helpers/extensions.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                // Doctor Avatar
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                  child: Text(
                    appointment.doctorName.isNotEmpty 
                        ? appointment.doctorName[0].toUpperCase() 
                        : 'D',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        appointment.specialization,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                _buildStatusBadge(appointment.status, context),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Date and Time Row
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        icon: Icons.calendar_today_outlined,
                        label: DateFormat('MMM d, yyyy').format(appointment.appointmentDate),
                        context: context,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _infoRow(
                        icon: Icons.access_time_outlined,
                        label: appointment.startTime.time,
                        context: context,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Location and Price Row
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        icon: appointment.isOnline ?? false 
                            ? Icons.videocam_outlined 
                            : Icons.location_on_outlined,
                        label: appointment.isOnline ?? false 
                            ? context.l10n.onlineConsultation 
                            : appointment.location ?? context.l10n.inPerson,
                        context: context,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${appointment.price.toStringAsFixed(0)} EGP',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Payment Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.payment,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    _buildPaymentBadge(appointment.paymentStatus, context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColor.primaryColor.withOpacity(0.7),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            style: context.theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(AppointmentStatus status, BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case AppointmentStatus.pending:
        color = Colors.orange;
        label = context.l10n.pending;
        break;
      case AppointmentStatus.confirmed:
        color = AppColor.primaryColor;
        label = context.l10n.confirmed;
        break;
      case AppointmentStatus.cancelled:
        color = Colors.red;
        label = context.l10n.cancelled;
        break;
      case AppointmentStatus.completed:
        color = Colors.green;
        label = context.l10n.completed;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentBadge(PaymentStatus status, BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case PaymentStatus.unpaid:
        color = Colors.red;
        label = context.l10n.unpaid;
        icon = Icons.payment_outlined;
        break;
      case PaymentStatus.paid:
        color = Colors.green;
        label = context.l10n.paid;
        icon = Icons.check_circle_outline;
        break;
      case PaymentStatus.refunded:
        color = Colors.grey;
        label = context.l10n.refunded;
        icon = Icons.refresh;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
