import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.right,
    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 2.1, // Sufficient line height to avoid clipping diacritics / tashkeel
      color: color ?? Theme.of(context).colorScheme.onSurface,
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
