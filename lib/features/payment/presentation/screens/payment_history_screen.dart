import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/features/payment/presentation/cubit/payment_history_cubit.dart';
import 'package:alagy/features/payment/presentation/widgets/payment_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PaymentHistoryCubit>()
        ..getPaymentHistory(context.read<AppUserCubit>().state.user?.uid ?? ''),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.paymentHistory,
              style: const TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
          builder: (context, state) {
            if (state is PaymentHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PaymentHistoryError) {
              return Center(child: Text(state.message));
            } else if (state is PaymentHistoryEmpty) {
              return Center(child: Text(context.l10n.noPaymentsFound));
            } else if (state is PaymentHistoryLoaded) {
              return ListView.separated(
                padding: EdgeInsets.all(16.r),
                itemCount: state.payments.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return PaymentHistoryItem(payment: state.payments[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
