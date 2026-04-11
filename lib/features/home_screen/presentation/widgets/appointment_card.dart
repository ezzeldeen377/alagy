import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';

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
                        context.getSpecialty(appointment.specialization),
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
                        label: DateFormat('MMM d, yyyy')
                            .format(appointment.appointmentDate),
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
                        icon: appointment.appointmentType ==
                                AppointmentType.consultation
                            ? Icons.assignment_outlined
                            : Icons.history_rounded,
                        label: appointment.appointmentType.name.tr(context),
                        context: context,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                if (appointment.status == AppointmentStatus.pending ||
                    appointment.status == AppointmentStatus.confirmed) ...[
                  SizedBox(height: 16.h),
                  OutlinedButton(
                    onPressed: () => _showCancelBottomSheet(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: Size(double.infinity, 44.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      context.l10n.cancelAppointmentConfirmationTitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelBottomSheet(BuildContext context) {
    final tr = context.l10n;
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Calculate time difference
    final appointmentDateTime = DateTime(
      appointment.appointmentDate.year,
      appointment.appointmentDate.month,
      appointment.appointmentDate.day,
      appointment.startTime.toDateTime().hour,
      appointment.startTime.toDateTime().minute,
    );

    final difference = appointmentDateTime.difference(DateTime.now());
    final hoursRemaining = difference.inHours;
    final isLessThan3Hours = hoursRemaining < 3 && hoursRemaining >= 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  tr.cancelAppointmentConfirmationTitle,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  tr.cancelAppointmentConfirmationMessage,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),

                // 50% deduction warning for cancellations within 3 hours
                if (isLessThan3Hours) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                tr.cancellationWarning3Hours,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: Colors.red.withOpacity(0.1)),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                tr.originalPrice,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${appointment.price.toStringAsFixed(0)} ${tr.egp}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                tr.refunded,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${(appointment.price * 0.5).toStringAsFixed(0)} ${tr.egp}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 24.h),
                Text(
                  tr.cancellationReason,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: tr.pleaseEnterCancellationReason,
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16.r),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return tr.pleaseEnterCancellationReason;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text(
                          tr.cancel,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final user =
                                context.read<AppUserCubit>().state.user;
                            if (user != null) {
                              context.read<WalletCubit>().cancelAppointment(
                                    appointment,
                                    reasonController.text.trim(),
                                    user.uid,
                                    user.walletBalance,
                                  );
                            }
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          tr.confirm,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        ),
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

  Widget _buildPaymentBadge(
      AppointmentPaymentStatus status, BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case AppointmentPaymentStatus.unpaid:
        color = Colors.red;
        label = context.l10n.unpaid;
        icon = Icons.payment_outlined;
        break;
      case AppointmentPaymentStatus.paid:
        color = Colors.green;
        label = context.l10n.paid;
        icon = Icons.check_circle_outline;
        break;
      case AppointmentPaymentStatus.refunded:
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
