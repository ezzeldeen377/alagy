import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/helpers/notification_service.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/payment/data/models/payment_model.dart';
import 'package:alagy/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:alagy/features/payment/presentation/widgets/custom_payment_options_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paymob/paymob.dart';

class SelectPaymentOption extends StatefulWidget {
  const SelectPaymentOption({
    super.key,
  });

  @override
  State<SelectPaymentOption> createState() => _SelectPaymentOptionState();
}

class _SelectPaymentOptionState extends State<SelectPaymentOption> {
  /// Handles the Paymob card payment flow after the intention key is obtained.
  Future<void> _handleCardPayment(
    BuildContext context,
    PaymentState state,
  ) async {
    final result = await Paymob.pay(
      publicKey: paymentKeys.publicKey,
      clientSecret: state.paymentKey!,
      appName: 'Roshta',
    );

    if (!context.mounted) return;

    if (result.isSuccessful) {
      final cubit = context.read<PaymentCubit>();
      final user = context.read<AppUserCubit>().state.user;

      cubit.savePayment(PaymentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user?.uid ?? '',
        amount: state.appointment?.price ?? 0.0,
        date: DateTime.now(),
        status: 'success',
        method: 'Card',
        description: 'Appointment with ${state.appointment?.doctorName}',
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      ));

      cubit.makeAppointment(
        state.appointment!
            .copyWith(paymentStatus: AppointmentPaymentStatus.paid),
        user?.uid ?? '',
      );
    } else {
      showSnackBar(
        context,
        result.errorMessage ?? context.l10n.paymentFailed,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppUserCubit>().state.user;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  context.l10n.select,
                  style: TextStyles.fontCircularSpotify28PrimaryBold,
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 10.h,
                ),
                itemCount: AppConstants.paymentMethods.length,
                itemBuilder: (context, index) => CustomPaymentOptionsItem(
                    paymentType: AppConstants.paymentMethods[index]),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state.status == PaymentStatus.success) {
              if (state.paymentKey == 'WALLET_PAYMENT') {
                final String uid = context.read<AppUserCubit>().state.user!.uid;
                context
                    .read<PaymentCubit>()
                    .makeAppointment(state.appointment!, uid);
              } else {
                _handleCardPayment(context, state);
              }
            } else if (state.status == PaymentStatus.appointmentCreated) {
              showSnackBar(context, context.l10n.paymentSuccess,
                  backgroundColor: Colors.green);
              final user = context.read<AppUserCubit>().state.user;
              if (user != null) {
                context.read<AppUserCubit>().getUser(uid: user.uid);
              }
              context.pushNamedAndRemoveAll(RouteNames.initial);
              NotificationService.sendNotification(
                state.appointment?.doctorNotificationToken ?? "",
                context.l10n.newBooking,
                context.l10n.patientBookedNewAppointment,
              );
              context.read<PaymentCubit>().createAppointmentNotification(
                    title: context.l10n.appointmentConfirmedTitle,
                    body: context.l10n.appointmentConfirmedBody(
                      state.appointment!.doctorName,
                      DateFormat('MMM dd, yyyy')
                          .format(state.appointment!.appointmentDate),
                      state.appointment!.startTime.time,
                    ),
                    appointmentDate: state.appointment!.appointmentDate,
                    appointmentTime: state.appointment!.startTime.time,
                    doctorName: state.appointment!.doctorName,
                    userId: context.read<AppUserCubit>().state.user!.uid,
                  );
            } else if (state.status == PaymentStatus.error) {
              showSnackBar(context, state.errorMessage ?? "",
                  backgroundColor: Colors.red);
            }
          },
          builder: (context, state) {
            if (state.status == PaymentStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }

            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: AppColor.primaryColor,
                    disabledBackgroundColor: AppColor.fifthColor),
                onPressed: state.selectedOption == null
                    ? null
                    : () {
                        if (state.selectedOption?.key == "internalWallet") {
                          final walletBalance = user?.walletBalance ?? 0.0;
                          final price = state.appointment?.price ?? 0.0;
                          if (walletBalance >= price) {
                            context.read<PaymentCubit>().processWalletPayment(
                                  userId: user!.uid,
                                  amount: price,
                                  currentBalance: walletBalance,
                                );
                          } else {
                            showSnackBar(
                                context, context.l10n.insufficientBalance,
                                backgroundColor: Colors.red);
                          }
                        } else {
                          context.read<PaymentCubit>().processPayment(
                                amount: state.appointment?.price ?? 0.0,
                                orderId: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                customerName: user?.name ?? "not found",
                                customerEmail: user?.email ?? "not found",
                                customerPhone: user?.phoneNumber != null &&
                                        user!.phoneNumber!.isNotEmpty
                                    ? user.phoneNumber!
                                    : "not found",
                                customerFirstName: user?.name ?? "not found",
                                customerLastName: user?.name ?? "not found",
                                city: user?.city ?? "not found",
                                country: 'Egypt',
                              );
                        }
                      },
                child: Text(
                  context.l10n.choose,
                  style: TextStyles.fontCircularSpotify20WhiteSemiBold,
                ));
          },
        ),
      ),
    );
  }
}
