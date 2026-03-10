import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:alagy/features/payment/presentation/screens/i_frame_web_view_screen.dart';
import 'package:alagy/features/payment/presentation/widgets/custom_payment_options_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPaymentOption extends StatefulWidget {
  const SelectPaymentOption({
    super.key,
  });

  @override
  State<SelectPaymentOption> createState() => _SelectPaymentOptionState();
}

class _SelectPaymentOptionState extends State<SelectPaymentOption> {
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
            Text(
              context.l10n.select,
              style: TextStyles.fontCircularSpotify28PrimaryBold,
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
              context.push(BlocProvider.value(
                value: context.read<PaymentCubit>(),
                child: IFrameWebViewScreen(),
              ));
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
                        context.read<PaymentCubit>().processPayment(
                              amount: state.appointment!.price,
                              orderId: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              customerName: user?.name ?? "not found",
                              customerEmail: user?.email ?? "not found",
                              customerPhone: user?.phoneNumber ?? "not found",
                              customerFirstName: user?.name ?? "not found",
                              customerLastName: user?.name ?? "not found",
                              city: user?.city ?? "not found",
                              country: 'Egypt',
                            );
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
