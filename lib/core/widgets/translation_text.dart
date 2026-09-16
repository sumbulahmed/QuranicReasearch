import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Clean literary translation text widget styled for long-form readability.
/// Supports both English and Urdu translation text with pure black styling
/// in light mode and high-contrast cream in dark mode.
class TranslationText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final double height;
  final bool isUrdu;
  final TextDirection? textDirection;

  const TranslationText(
    this.text, {
    super.key,
    this.fontSize = 16.5,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign = TextAlign.left,
    this.height = 1.65,
    this.isUrdu = false,
    this.textDirection,
  });

  const TranslationText.urdu(
    this.text, {
    super.key,
    this.fontSize = 15.5,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.right,
    this.height = 1.8,
    this.isUrdu = true,
    this.textDirection = TextDirection.rtl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ??
        (isDark ? AppColors.translationTextDark : AppColors.translationTextLight);

    final fontStyle = isUrdu
        ? GoogleFonts.amiri(
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: height,
            color: defaultColor,
          )
        : GoogleFonts.ebGaramond(
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: height,
            color: defaultColor,
          );

    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection ?? (isUrdu ? TextDirection.rtl : TextDirection.ltr),
      style: fontStyle,
    );
  }
}
