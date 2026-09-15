import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Clean literary translation text widget styled for long-form readability.
class TranslationText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final double height;

  const TranslationText(
    this.text, {
    super.key,
    this.fontSize = 16.5,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign = TextAlign.left,
    this.height = 1.65,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ??
        (isDark ? AppColors.translationTextDark : AppColors.translationTextLight);

    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.ebGaramond(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        color: defaultColor,
      ),
    );
  }
}
