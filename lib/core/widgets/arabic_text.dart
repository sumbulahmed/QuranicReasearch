import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Traditional Arabic calligraphy display widget using the authentic Amiri font.
/// Enforces generous vertical line heights to prevent clipping of tashkeel/diacritics.
class ArabicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final bool isSelectable;

  const ArabicText(
    this.text, {
    super.key,
    this.fontSize = 25.0,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.textAlign = TextAlign.right,
    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ??
        (isDark ? AppColors.darkTextPrimary : const Color(0xFF1F1514));

    final style = GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 2.15, // Essential multiplier to completely avoid clipping diacritics
      color: defaultColor,
    );

    if (isSelectable) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SelectableText(
          text,
          textAlign: textAlign,
          style: style,
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textAlign: textAlign,
        style: style,
      ),
    );
  }
}
