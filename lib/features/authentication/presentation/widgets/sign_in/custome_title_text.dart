import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/font_weight_helper.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeTitleText extends StatelessWidget {
  final String title;
  final String animatedText;
  final EdgeInsetsGeometry padding;


  const CustomeTitleText({
    super.key,
    required this.title,
    required this.animatedText,
    this.padding = const EdgeInsets.all(35),

  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.displayMedium
                ?.copyWith(fontWeight: FontWeightHelper.bold),
          ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                animatedText,
                textStyle: theme.textTheme.bodyLarge,
                speed: const Duration(milliseconds: 100),
              ),
            ],
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
        ],
      ),
    );
  }
}
