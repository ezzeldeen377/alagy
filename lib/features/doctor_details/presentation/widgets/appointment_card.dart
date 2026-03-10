import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointment appointment;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Expanded(
                child: Text(
                  appointment.patientName,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Appointment details
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                DateFormat('MMM dd, yyyy').format(appointment.appointmentDate),
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                '${appointment.startTime} - ${appointment.endTime}',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Specialization and price
          Row(
            children: [
              Icon(
                Icons.medical_services,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                appointment.specialization,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                'EGP ${appointment.price.toStringAsFixed(2)}',
                style: context.theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),

          // Payment status
          if (appointment.paymentStatus != PaymentStatus.unpaid) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  appointment.paymentStatus == PaymentStatus.paid
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 16.sp,
                  color: appointment.paymentStatus == PaymentStatus.paid
                      ? Colors.green
                      : Colors.orange,
                ),
                SizedBox(width: 8.w),
                Text(
                  _getPaymentStatusText(),
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: appointment.paymentStatus == PaymentStatus.paid
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          // Notes
          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                appointment.notes!,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],

          // Action buttons
          if (_hasActions()) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                if (onReject != null || onCancel != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject ?? onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        appointment.status == AppointmentStatus.pending
                            ? 'Reject'
                            : 'Cancel',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                if ((onReject != null || onCancel != null) &&
                    (onAccept != null || onComplete != null))
                  SizedBox(width: 12.w),
                if (onAccept != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                if (onComplete != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Complete',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.blue;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getPaymentStatusText() {
    switch (appointment.paymentStatus) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.unpaid:
        return 'Unpaid';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  bool _hasActions() {
    return onAccept != null || onReject != null || onComplete != null || onCancel != null;
  }
}