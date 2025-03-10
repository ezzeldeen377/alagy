import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomeAlreadyHaveAnAccountRow extends StatelessWidget {
  final VoidCallback onTap;
  const CustomeAlreadyHaveAnAccountRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          context.l10n.alreadyHaveAccount,
          style: context.theme.textTheme.labelLarge,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context,RouteNames.signIn);
          },
          child: Text(
            context.l10n.signIn,
            style: context.theme.textTheme.labelLarge?.copyWith(color: AppColor.tealNew),
          ),
        ),
      ],
    );
  }
}
