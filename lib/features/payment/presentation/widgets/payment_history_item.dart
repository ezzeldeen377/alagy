import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:alagy/features/payment/data/models/payment_model.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PaymentHistoryItem extends StatelessWidget {
  final PaymentModel payment;

  const PaymentHistoryItem({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final isSuccess = payment.status.toLowerCase() == 'success';
    final statusText = isSuccess
        ? context.l10n.paymentSuccess
        : (payment.status.toLowerCase() == 'failed'
            ? context.l10n.paymentFailed
            : payment.status);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EGP ${payment.amount}',
                style: TextStyles.fontCircularSpotify20WhiteSemiBold.copyWith(
                  color: AppColor.blackColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            payment.description,
            style: TextStyles.fontCircularSpotify14LightBlackMedium
                .copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a',
                    context.read<AppSettingsCubit>().state.locale.languageCode)
                .format(payment.date),
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
