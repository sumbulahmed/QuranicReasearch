import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

/// Renders the unfolded parchment letter revealing the sacred brand emblem,
/// classical manuscript calligraphy, and warm radiant illumination.
class LetterRevealAnimation extends StatelessWidget {
  final double slideProgress; // 0.0 (inside envelope) to 1.0 (fully lifted)
  final double unfoldProgress; // 0.0 (folded) to 1.0 (fully unfolded)
  final double glowIntensity; // 0.0 (none) to 1.0 (full warm light bloom)
  final double brandProgress; // 0.0 (hidden) to 1.0 (fully inked)
  final double width;
  final double height;
  final bool isDark;

  const LetterRevealAnimation({
    super.key,
    required this.slideProgress,
    required this.unfoldProgress,
    required this.glowIntensity,
    required this.brandProgress,
    this.width = 280,
    this.height = 360,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Current letter height expands as it unfolds
    final currentHeight = (height * (0.50 + unfoldProgress * 0.50)).clamp(height * 0.5, height);
    // Vertical lift offset
    final verticalOffset = (1.0 - slideProgress) * 90.0;

    final headingColor = isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final goldTone = isDark ? AppColors.accentGoldLight : AppColors.accentGold;

    return Transform.translate(
      offset: Offset(0, verticalOffset - (unfoldProgress * 30.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. Soft Warm Light Bloom emerging from the letter
          if (glowIntensity > 0.01)
            Positioned(
              top: -30,
              child: CustomPaint(
                size: Size(width * 1.3, height * 1.1),
                painter: _LightGlowPainter(
                  intensity: glowIntensity,
                  isDark: isDark,
                ),
              ),
            ),

          // 2. Parchment Paper Sheet
          CustomPaint(
            size: Size(width, currentHeight),
            painter: _ParchmentLetterPainter(
              unfoldProgress: unfoldProgress,
              isDark: isDark,
            ),
          ),

          // 3. Brand Content Revealed on the Parchment (Medallion, Title, Calligraphy)
          if (brandProgress > 0.02)
            SizedBox(
              width: width,
              height: currentHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                child: Opacity(
                  opacity: brandProgress.clamp(0.0, 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Illuminated App Emblem Medallion
                      Transform.scale(
                        scale: (0.85 + brandProgress * 0.15).clamp(0.85, 1.0),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF261D1A)
                                : const Color(0xFFFBF6EC),
                            border: Border.all(
                              color: goldTone.withValues(alpha: 0.85),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: goldTone.withValues(alpha: 0.25 * brandProgress),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Subtle 8-pointed star in the background of medallion
                              Icon(
                                Icons.auto_awesome,
                                size: 36,
                                color: goldTone,
                              ),
                              Icon(
                                Icons.science_outlined,
                                size: 19,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.primaryMaroon,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // App Title: BAYAN with settling letter-spacing
                      Text(
                        'BAYAN',
                        style: GoogleFonts.ebGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 5.5 - ((1.0 - brandProgress) * 2.0),
                          color: headingColor,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Subtitle: Quran & Science Research
                      Text(
                        'Quran & Science Research',
                        style: GoogleFonts.ebGaramond(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.6,
                          color: subtitleColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 14),

                      // Classical Manuscript Rule & Miniature Diamond
                      SizedBox(
                        width: 96,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.9,
                                color: goldTone.withValues(alpha: 0.50),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Transform.rotate(
                                angle: math.pi / 4,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  color: goldTone.withValues(alpha: 0.75),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 0.9,
                                color: goldTone.withValues(alpha: 0.50),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Delicate Traditional Ink Motto in classical serif
                      Text(
                        'كِتَابٌ أَنزَلْنَاهُ إِلَيْكَ مُبَارَكٌ لِّيَدَّبَّرُوا آيَاتِهِ',
                        style: GoogleFonts.amiri(
                          fontSize: 13,
                          color: (isDark ? AppColors.accentGoldLight : AppColors.accentSepia)
                              .withValues(alpha: 0.85 * brandProgress),
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Paints the aged manuscript parchment sheet with deckled edges and fine ruling lines.
class _ParchmentLetterPainter extends CustomPainter {
  final double unfoldProgress;
  final bool isDark;

  const _ParchmentLetterPainter({
    required this.unfoldProgress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));

    // Deep soft drop shadow under the parchment paper
    final shadowPaint = Paint()
      ..color = (isDark ? Colors.black : const Color(0xFF3B271A)).withValues(alpha: isDark ? 0.50 : 0.24)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawRRect(rrect.shift(const Offset(0, 6)), shadowPaint);

    // Warm Antique Parchment Paper Gradient
    final paperPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                const Color(0xFF2B211E),
                const Color(0xFF221A17),
                const Color(0xFF1E1714),
              ]
            : [
                const Color(0xFFFFFDF8),
                const Color(0xFFFBF5E8),
                const Color(0xFFF3E9D5),
              ],
      ).createShader(rect);
    canvas.drawRRect(rrect, paperPaint);

    // Outer Antique Double Border framing the document
    final outerBorderPaint = Paint()
      ..color = (isDark ? const Color(0xFF4A3A32) : const Color(0xFFCBBDA4)).withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, outerBorderPaint);

    const inset = 7.0;
    final innerRect = Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2);
    final innerRRect = RRect.fromRectAndRadius(innerRect, const Radius.circular(3));
    final innerBorderPaint = Paint()
      ..color = (isDark ? const Color(0xFF4A3A32) : const Color(0xFFDCD0BA)).withValues(alpha: 0.50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    canvas.drawRRect(innerRRect, innerBorderPaint);

    // Faint Manuscript Ruling Lines across the parchment paper
    final rulePaint = Paint()
      ..color = (isDark ? const Color(0xFF382B24) : const Color(0xFFE4D9C4)).withValues(alpha: 0.40)
      ..strokeWidth = 0.5;

    const lineSpacing = 16.0;
    final startY = 32.0;
    final endY = size.height - 24.0;
    for (double y = startY; y < endY; y += lineSpacing) {
      // Don't draw through the center emblem area
      if (y > size.height * 0.28 && y < size.height * 0.76) continue;
      canvas.drawLine(
        Offset(inset + 10, y),
        Offset(size.width - inset - 10, y),
        rulePaint,
      );
    }

    // Unfold Crease line across the middle of the letter
    if (unfoldProgress < 0.98) {
      final creaseY = size.height * 0.5;
      final creasePaint = Paint()
        ..color = (isDark ? Colors.black : const Color(0xFF5A4332)).withValues(alpha: (1.0 - unfoldProgress) * 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
        ..strokeWidth = 1.5;
      canvas.drawLine(
        Offset(inset, creaseY),
        Offset(size.width - inset, creaseY),
        creasePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParchmentLetterPainter old) =>
      old.unfoldProgress != unfoldProgress || old.isDark != isDark;
}

/// Paints the warm golden radial illumination bloom emanating from the unsealed letter.
class _LightGlowPainter extends CustomPainter {
  final double intensity;
  final bool isDark;

  const _LightGlowPainter({
    required this.intensity,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final radius = size.width * 0.65;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.85,
        colors: [
          (isDark ? const Color(0xFFFFE0A0) : const Color(0xFFFFEEB8)).withValues(alpha: 0.42 * intensity),
          (isDark ? const Color(0xFFD4B372) : const Color(0xFFE2C488)).withValues(alpha: 0.20 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(_LightGlowPainter old) =>
      old.intensity != intensity || old.isDark != isDark;
}
