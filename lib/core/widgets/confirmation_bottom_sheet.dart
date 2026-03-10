import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/discount/presentation/cubit/discount_code_cubit.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ConfirmationBottomSheet extends StatefulWidget {
  final DoctorAppointment appointment;
  final VoidCallback onConfirm;

  const ConfirmationBottomSheet({
    Key? key,
    required this.appointment,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<ConfirmationBottomSheet> createState() =>
      _ConfirmationBottomSheetState();

  /// Static method to show the bottom sheet
  static void show(BuildContext context, DoctorAppointment appointment,
      VoidCallback onConfirm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (_) => getIt<DiscountCodeCubit>(),
          child: ConfirmationBottomSheet(
            appointment: appointment,
            onConfirm: onConfirm,
          ),
        );
      },
    );
  }
}

class _ConfirmationBottomSheetState extends State<ConfirmationBottomSheet> {
  final TextEditingController couponController = TextEditingController();
  late double finalPrice;

  @override
  void initState() {
    super.initState();
    finalPrice = widget.appointment.price;
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (couponController.text.trim().isEmpty) return;
    context.read<DiscountCodeCubit>().validateDiscountCode(
          couponController.text.trim(),
          widget.appointment.price,
        );
  }

  void _removeCoupon() {
    couponController.clear();
    context.read<DiscountCodeCubit>().removeDiscount();
    setState(() {
      finalPrice = widget.appointment.price;
    });
  }

  Future<void> _onConfirm() async {
    final discountState = context.read<DiscountCodeCubit>().state;

    // Increment usage count if discount is applied
    if (discountState is DiscountCodeApplied) {
      await context
          .read<DiscountCodeCubit>()
          .incrementUsage(discountState.discountCode.id);
      finalPrice = discountState.finalPrice;
    }

    widget.onConfirm.call();

    // Create updated appointment with final price
    final updatedAppointment = DoctorAppointment(
      id: widget.appointment.id,
      appointmentType: widget.appointment.appointmentType,
      doctorId: widget.appointment.doctorId,
      doctorName: widget.appointment.doctorName,
      specialization: widget.appointment.specialization,
      appointmentDate: widget.appointment.appointmentDate,
      startTime: widget.appointment.startTime,
      endTime: widget.appointment.endTime,
      price: finalPrice, // Use the discounted price
      location: widget.appointment.location,
      isOnline: widget.appointment.isOnline,
      status: widget.appointment.status,
      paymentStatus: widget.appointment.paymentStatus,
      patientId: widget.appointment.patientId,
      patientName: widget.appointment.patientName,
      notes: widget.appointment.notes,
      createdAt: widget.appointment.createdAt,
      updatedAt: DateTime.now(),
      doctorNotificationToken: widget.appointment.doctorNotificationToken,
      patientNotificationToken: widget.appointment.patientNotificationToken,
    );

    if (mounted) {
      context.pop();
      context.pushNamed(RouteNames.selectPayment,
          arguments: updatedAppointment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 10.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
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
            SizedBox(height: 20.h),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.confirmAppointment,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon:
                      Icon(Icons.close, color: AppColor.greyColor, size: 24.sp),
                )
              ],
            ),
            Text(
              context.l10n.pleaseReviewTheAppointmentDetailsBeforeConfirming,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: AppColor.greyColor,
              ),
            ),
            SizedBox(height: 20.h),

            // Appointment Details Card - Human Design
            Container(
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. Doctor Profile Section
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        Container(
                          width: 50.r,
                          height: 50.r,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_rounded,
                              color: AppColor.primaryColor, size: 28.sp),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.doctor,
                                style: context.theme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppColor.greyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.appointment.doctorName,
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                context.getSpecialty(
                                    widget.appointment.specialization),
                                style:
                                    context.theme.textTheme.bodySmall?.copyWith(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),

                  // 2. Schedule Section (Grouped visually)
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded,
                                        size: 16.sp, color: AppColor.greyColor),
                                    SizedBox(width: 6.w),
                                    Text(context.l10n.date,
                                        style: context
                                            .theme.textTheme.labelSmall
                                            ?.copyWith(
                                                color: AppColor.greyColor)),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  DateFormat(
                                          'EEE, MMM d',
                                          context
                                              .read<AppSettingsCubit>()
                                              .state
                                              .locale
                                              .languageCode)
                                      .format(
                                          widget.appointment.appointmentDate),
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded,
                                        size: 16.sp, color: AppColor.greyColor),
                                    SizedBox(width: 6.w),
                                    Text(context.l10n.time,
                                        style: context
                                            .theme.textTheme.labelSmall
                                            ?.copyWith(
                                                color: AppColor.greyColor)),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  widget.appointment.startTime.time,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Location & Status (Footer style)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.03),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20.r)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.appointment.location != null)
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.location_on_rounded,
                                    size: 16.sp, color: AppColor.primaryColor),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    widget.appointment.location!,
                                    style: context.theme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(), // Spacer
                        // Payment Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: widget.appointment.paymentStatus ==
                                    PaymentStatus.paid
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                widget.appointment.paymentStatus ==
                                        PaymentStatus.paid
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.pending_outlined,
                                size: 14.sp,
                                color: widget.appointment.paymentStatus ==
                                        PaymentStatus.paid
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                widget.appointment.paymentStatus ==
                                        PaymentStatus.paid
                                    ? context.l10n.paided
                                    : context.l10n.unpaid,
                                style: context.theme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: widget.appointment.paymentStatus ==
                                          PaymentStatus.paid
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
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
            SizedBox(height: 24.h),

            // Coupon Section
            Text(
              context.l10n.couponCode,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            BlocConsumer<DiscountCodeCubit, DiscountCodeState>(
              listener: (context, state) {
                if (state is DiscountCodeApplied) {
                  setState(() {
                    finalPrice = state.finalPrice;
                  });
                } else if (state is DiscountCodeInitial) {
                  setState(() {
                    finalPrice = widget.appointment.price;
                  });
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: couponController,
                            decoration: InputDecoration(
                              hintText: context.l10n.enterCouponCode,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.discount_outlined,
                                  color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                    color: AppColor.primaryColor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              errorText: state is DiscountCodeError
                                  ? state.message
                                  : null,
                            ),
                            textCapitalization: TextCapitalization.characters,
                            enabled: state is! DiscountCodeLoading,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        if (state is! DiscountCodeApplied)
                          SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: state is DiscountCodeLoading
                                  ? null
                                  : _applyCoupon,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                              ),
                              child: state is DiscountCodeLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(context.l10n.apply),
                            ),
                          )
                        else
                          SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: _removeCoupon,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.1),
                                foregroundColor: Colors.red,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                              ),
                              child: Text(context.l10n.remove),
                            ),
                          ),
                      ],
                    ),
                    if (state is DiscountCodeApplied) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8.r),
                          border:
                              Border.all(color: Colors.green.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.green, size: 20.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                '${context.l10n.coupon} "${state.discountCode.name}" applied! You saved EGP${state.discountAmount.toStringAsFixed(2)}',
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),

            SizedBox(height: 24.h),
            const Divider(),
            SizedBox(height: 16.h),

            // Price Breakdown
            BlocBuilder<DiscountCodeCubit, DiscountCodeState>(
              builder: (context, state) {
                if (state is DiscountCodeApplied) {
                  return Column(
                    children: [
                      _buildPriceRow(context, context.l10n.originalPrice,
                          'EGP${widget.appointment.price.toStringAsFixed(2)}'),
                      SizedBox(height: 8.h),
                      _buildPriceRow(context, context.l10n.discount,
                          '-EGP${state.discountAmount.toStringAsFixed(2)}',
                          isDiscount: true),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const Divider(
                          color: Colors.grey,
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ),
                      _buildPriceRow(context, context.l10n.finalPrice,
                          'EGP${state.finalPrice.toStringAsFixed(2)}',
                          isTotal: true),
                    ],
                  );
                } else {
                  return _buildPriceRow(context, context.l10n.finalPrice,
                      'EGP${widget.appointment.price.toStringAsFixed(2)}',
                      isTotal: true);
                }
              },
            ),
            SizedBox(height: 32.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      foregroundColor: AppColor.blackColor,
                    ),
                    child: Text(
                      context.l10n.cancel,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 4,
                      shadowColor: AppColor.primaryColor.withOpacity(0.4),
                    ),
                    child: Text(
                      context.l10n.confirm,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? context.theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)
              : context.theme.textTheme.bodyMedium?.copyWith(
                  color: AppColor.greyColor,
                  fontWeight: FontWeight.w500,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                )
              : context.theme.textTheme.bodyMedium?.copyWith(
                  color: isDiscount ? Colors.red : AppColor.blackColor,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}
