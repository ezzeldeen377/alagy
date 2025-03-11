import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/spacer.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomDontHaveAccountRow extends StatelessWidget {
  final VoidCallback onTap;

  const CustomDontHaveAccountRow({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          context.l10n.dontHaveAccount,
          style: context.theme.textTheme.labelLarge
        ),
        horizontalSpace(5),
        InkWell(
          onTap: onTap,
          child:  Text(
            context.l10n.registerNow,
            style: context.theme.textTheme.labelLarge?.copyWith(color: AppColor.tealNew),
          ),
        ),
      ],
    );
  }
}
