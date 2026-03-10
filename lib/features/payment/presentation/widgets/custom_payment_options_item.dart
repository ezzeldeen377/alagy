import 'package:alagy/core/common/enities/payment_type.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:alagy/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPaymentOptionsItem extends StatelessWidget {
  const CustomPaymentOptionsItem({
    super.key,
    required this.paymentType,
    this.isDisabled = false, // Add disabled state
  });

  final PaymentType paymentType;
  final bool isDisabled; // New parameter

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        final isSelected=state.selectedOption==paymentType;
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 25.w),
          tileColor:context.isDark?const Color.fromARGB(255, 48, 46, 46): const Color.fromARGB(255, 242, 248, 254),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
          ),
          leading: SvgPicture.asset(
            paymentType.paymentIcon,
            colorFilter:  ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
          ),
          onTap: () {
            context.read<PaymentCubit>().onSelectOption(paymentType);
          }, // Disable tap if inactive
          title: Text(
            paymentType.paymentName,
            style: TextStyles.fontCircularSpotify14BlackRegular
          ),
          trailing: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isSelected
                  ? AppColor.primaryColor.withOpacity(0.3)
                  : Color(0xffD9D9D9)),
            ),
            child: CircleAvatar(
              backgroundColor: (isSelected
                  ? AppColor.primaryColor
                  : Color(0xffBBBBBB)),
              radius: 8.r,
            ),
          ),
        );
      },
    );
  }
}
