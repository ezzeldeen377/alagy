import 'dart:developer';

import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/helpers/notification_service.dart';
import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/payment/presentation/cubit/payment_cubit.dart'
    hide PaymentStatus;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/payment/data/models/payment_model.dart'; // Add

class IFrameWebViewScreen extends StatefulWidget {
  const IFrameWebViewScreen({
    super.key,
  });
  @override
  State<IFrameWebViewScreen> createState() => _IFrameWebViewScreenState();
}

class _IFrameWebViewScreenState extends State<IFrameWebViewScreen> {
  InAppWebViewController? controller;
  bool _paymentProcessed = false; // Add flag to prevent duplicate processing

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentCubit>();
    final user = context.read<AppUserCubit>().state.user;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state.isAppointmentCreated) {
            context.pushNamedAndRemoveAll(RouteNames.initial);
            log(state.appointment?.doctorNotificationToken ?? " no token");
            NotificationService.sendNotification(
              state.appointment?.doctorNotificationToken ?? "",
              l10n.newBooking,
              l10n.patientBookedNewAppointment,
            );
            cubit.createAppointmentNotification(
                appointmentDate: state.appointment!.appointmentDate,
                appointmentTime: state.appointment!.startTime.time,
                doctorName: state.appointment!.doctorName,
                userId: context.read<AppUserCubit>().state.user!.uid);
          }
          if (state.isError) {
            showSnackBar(context, state.errorMessage ?? l10n.paymentError,
                backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          return InAppWebView(
            initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
            initialUrlRequest: URLRequest(
              url: WebUri(
                  "https://accept.paymob.com/unifiedcheckout/?publicKey=${paymentKeys.publicKey}&clientSecret=${state.paymentKey}"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
            onWebViewCreated: (InAppWebViewController webViewController) {
              controller = webViewController;
            },
            onLoadStart: (controller, url) {
              debugPrint("${l10n.loadingPayment}: $url");
            },
            onLoadStop: (controller, url) {
              if (url == null || _paymentProcessed) return;

              final uri = Uri.parse(url.toString());
              final successParam = uri.queryParameters['success'];

              if (successParam == 'true') {
                print(l10n.paymentSuccess);
                _paymentProcessed =
                    true; // Set flag to prevent duplicate processing

                final payment = PaymentModel(
                  id: uri.queryParameters['id'] ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: user?.uid ?? "",
                  amount: state.appointment?.price ?? 0.0,
                  date: DateTime.now(),
                  status: 'success',
                  method: 'Card',
                  description:
                      'Appointment with ${state.appointment?.doctorName}',
                  transactionId: uri.queryParameters['id'] ?? '',
                );
                cubit.savePayment(payment);

                // Only call makeAppointment once here - the listener will handle the rest
                cubit.makeAppointment(
                    state.appointment!
                        .copyWith(paymentStatus: PaymentStatus.paid),
                    user?.uid ?? "");
              } else if (successParam == 'false') {
                showSnackBar(context, l10n.paymentFailed,
                    backgroundColor: Colors.red);
              } else {
                print("No success param in URL");
              }
            },
            onLoadError: (controller, url, code, message) {
              debugPrint("${l10n.paymentError}: $message");
            },
          );
        },
      ),
    );
  }
}
