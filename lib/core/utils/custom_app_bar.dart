import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? buttonText;
  
  const CustomAppBar({super.key, required this.title, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: Text(context.l10n.editDoctorTitle,
              style: context.theme.textTheme.headlineSmall?.copyWith(color: AppColor.white)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.mintGreen,
                  AppColor.tealNew,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 4,
          actions: [
           buttonText!=null? IconButton(
              icon: Text(
                buttonText!,
                style: const TextStyle(
                  color: AppColor.grayColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: () {
context.pushNamedAndRemoveAll(RouteNames.initial)              ;},
            ):const SizedBox.shrink(),
          ],
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}