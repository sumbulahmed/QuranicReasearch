import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Renders the vintage envelope with deckled parchment texture, 3D folding top flap,
/// and a hand-crafted wax seal with an authentic Islamic geometric emblem.
class AnimatedEnvelope extends StatelessWidget {
  final double flapProgress; // 0.0 (closed) to 1.0 (fully open)
  final double sealBreakProgress; // 0.0 (intact) to 1.0 (opened/fractured)
  final double width;
  final double height;
  final bool isDark;

  const AnimatedEnvelope({
    super.key,
    required this.flapProgress,
    required this.sealBreakProgress,
    this.width = 300,
    this.height = 190,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Flap rotation angle: 0 (flat down) to pi (flipped open up)
    final flapAngle = flapProgress * math.pi;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. Envelope Back Wall (interior cavity)
          CustomPaint(
            size: Size(width, height),
            painter: _EnvelopeBackPainter(isDark: isDark),
          ),

          // 2. Front Folded Pockets (Left, Right, Bottom flaps)
          CustomPaint(
            size: Size(width, height),
            painter: _EnvelopeFrontPocketPainter(isDark: isDark),
          ),

          // 3. Top Flap with 3D perspective fold
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0025) // 3D perspective perspective factor
                ..rotateX(-flapAngle),
              child: CustomPaint(
                size: Size(width, height * 0.58),
                painter: _EnvelopeTopFlapPainter(
                  isDark: isDark,
                  isBackSide: flapAngle > math.pi / 2,
                ),
              ),
            ),
          ),

          // 4. Wax Seal positioned at the flap point (visible while flap is still mostly closed)
          if (flapProgress < 0.65)
            Positioned(
              top: height * 0.52 - (flapProgress * height * 0.45),
              child: Opacity(
                opacity: (1.0 - (sealBreakProgress * 1.3)).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: (1.0 + (sealBreakProgress * 0.15)).clamp(0.8, 1.2),
                  child: CustomPaint(
                    size: const Size(48, 48),
                    painter: _WaxSealPainter(
                      fracture: sealBreakProgress,
                      isDark: isDark,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Paints the back interior wall of the vintage parchment envelope.
class _EnvelopeBackPainter extends CustomPainter {
  final bool isDark;

  const _EnvelopeBackPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    // Deep drop shadow
    final shadowPaint = Paint()
      ..color = (isDark ? Colors.black : const Color(0xFF35261C)).withValues(alpha: isDark ? 0.45 : 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawRRect(rrect.shift(const Offset(0, 8)), shadowPaint);

    // Interior cavity gradient (slightly darker shadow inside)
    final interiorPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1B1614), const Color(0xFF241D1A)]
            : [const Color(0xFFE4DAC3), const Color(0xFFEEE5D0)],
      ).createShader(rect);
    canvas.drawRRect(rrect, interiorPaint);

    // Subtle aging border
    final borderPaint = Paint()
      ..color = (isDark ? const Color(0xFF3F332D) : const Color(0xFFC7BBA5)).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(_EnvelopeBackPainter old) => old.isDark != isDark;
}

/// Paints the front folded triangular side and bottom pockets of the envelope.
class _EnvelopeFrontPocketPainter extends CustomPainter {
  final bool isDark;

  const _EnvelopeFrontPocketPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, 0, w, h);

    // Left folded flap path
    final leftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.46, h * 0.54)
      ..lineTo(0, h)
      ..close();

    // Right folded flap path
    final rightPath = Path()
      ..moveTo(w, 0)
      ..lineTo(w * 0.54, h * 0.54)
      ..lineTo(w, h)
      ..close();

    // Bottom triangular flap path (overlaps left and right)
    final bottomPath = Path()
      ..moveTo(0, h)
      ..lineTo(w * 0.50, h * 0.46)
      ..lineTo(w, h)
      ..close();

    final sidePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFF28201D), const Color(0xFF211B18)]
            : [const Color(0xFFF3EBDA), const Color(0xFFEAE0CD)],
      ).createShader(rect);

    final bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2E2521), const Color(0xFF241D1A)]
            : [const Color(0xFFFAF3E6), const Color(0xFFEFE6D4)],
      ).createShader(rect);

    final foldLinePaint = Paint()
      ..color = (isDark ? const Color(0xFF140E0C) : const Color(0xFFB5A791)).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw left and right flaps
    canvas.drawPath(leftPath, sidePaint);
    canvas.drawPath(leftPath, foldLinePaint);
    canvas.drawPath(rightPath, sidePaint);
    canvas.drawPath(rightPath, foldLinePaint);

    // Subtle shadow cast by bottom flap
    final bottomShadow = Paint()
      ..color = (isDark ? Colors.black : const Color(0xFF2A1C12)).withValues(alpha: isDark ? 0.35 : 0.14)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawPath(bottomPath.shift(const Offset(0, -2)), bottomShadow);

    // Draw bottom flap
    canvas.drawPath(bottomPath, bottomPaint);
    canvas.drawPath(bottomPath, foldLinePaint);
  }

  @override
  bool shouldRepaint(_EnvelopeFrontPocketPainter old) => old.isDark != isDark;
}

/// Paints the top triangular flap that unfolds upward.
class _EnvelopeTopFlapPainter extends CustomPainter {
  final bool isDark;
  final bool isBackSide;

  const _EnvelopeTopFlapPainter({
    required this.isDark,
    required this.isBackSide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final flapPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.5, h)
      ..lineTo(w, 0)
      ..close();

    final flapPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isBackSide
            ? (isDark
                ? [const Color(0xFF221A17), const Color(0xFF1D1614)]
                : [const Color(0xFFEBE0CD), const Color(0xFFE2D6C0)])
            : (isDark
                ? [const Color(0xFF332A26), const Color(0xFF29211E)]
                : [const Color(0xFFFCF6EA), const Color(0xFFF1E7D5)]),
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Outer shadow cast by flap onto lower envelope
    if (!isBackSide) {
      final flapShadow = Paint()
        ..color = (isDark ? Colors.black : const Color(0xFF2A1C12)).withValues(alpha: isDark ? 0.40 : 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawPath(flapPath.shift(const Offset(0, 3)), flapShadow);
    }

    canvas.drawPath(flapPath, flapPaint);

    // Edge crease
    final edgePaint = Paint()
      ..color = (isDark ? const Color(0xFF453831) : const Color(0xFFD4C7AF)).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    canvas.drawPath(flapPath, edgePaint);
  }

  @override
  bool shouldRepaint(_EnvelopeTopFlapPainter old) =>
      old.isDark != isDark || old.isBackSide != isBackSide;
}

/// Paints an authentic, organic vintage wax seal in deep maroon/crimson with an
/// embossed Islamic 8-pointed star (Rub el Hizb) emblem.
class _WaxSealPainter extends CustomPainter {
  final double fracture;
  final bool isDark;

  const _WaxSealPainter({
    required this.fracture,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 22.0;

    // Drop shadow under the thick melted wax seal
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center.translate(0, 2.5), radius, shadowPaint);

    // Realistic irregular melted wax rim
    final waxPath = Path();
    const numPoints = 28;
    for (int i = 0; i < numPoints; i++) {
      final angle = (i * 2 * math.pi) / numPoints;
      // Organic waviness in melted wax
      final r = radius + math.sin(i * 3.4) * 1.5 + math.cos(i * 1.7) * 1.0;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        waxPath.moveTo(x, y);
      } else {
        waxPath.lineTo(x, y);
      }
    }
    waxPath.close();

    // Deep crimson / maroon wax gradient
    final waxPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [
          Color(0xFF8B2335), // Highlighted wax ridge
          AppColors.primaryMaroon, // #5B1425
          Color(0xFF380811), // Deep shadow maroon
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(waxPath, waxPaint);

    // Inner embossed circle impression
    final stampRingPaint = Paint()
      ..color = const Color(0xFF3A0811).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawCircle(center, radius * 0.68, stampRingPaint);

    final stampHighlightPaint = Paint()
      ..color = const Color(0xFFB5475A).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(center.translate(-0.5, -0.5), radius * 0.68, stampHighlightPaint);

    // Embossed Islamic 8-Pointed Star (Rub el Hizb motif)
    _drawEmbossedStar(canvas, center, radius * 0.44);

    // Fracture line when seal opens
    if (fracture > 0.05) {
      final crackPaint = Paint()
        ..color = const Color(0xFFFFE6A3).withValues(alpha: (fracture * 0.9).clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 + (fracture * 1.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

      final crackPath = Path()
        ..moveTo(center.dx - radius * 0.8, center.dy - radius * 0.5)
        ..lineTo(center.dx - 2, center.dy)
        ..lineTo(center.dx + 4, center.dy + 3)
        ..lineTo(center.dx + radius * 0.8, center.dy + radius * 0.6);
      canvas.drawPath(crackPath, crackPaint);
    }
  }

  void _drawEmbossedStar(Canvas canvas, Offset center, double radius) {
    const points = 8;
    final outerR = radius;
    final innerR = radius * 0.48;

    final starPath = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (i * math.pi) / points - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      i == 0 ? starPath.moveTo(x, y) : starPath.lineTo(x, y);
    }
    starPath.close();

    // Shadow of the embossed star
    final starShadow = Paint()
      ..color = const Color(0xFF2A060C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(starPath.shift(const Offset(0.5, 0.5)), starShadow);

    // Gold highlight on the star
    final starGold = Paint()
      ..color = const Color(0xFFD4B372).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawPath(starPath, starGold);

    // Center tiny jewel dot
    canvas.drawCircle(
      center,
      1.5,
      Paint()..color = const Color(0xFFD4B372).withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_WaxSealPainter old) =>
      old.fracture != fracture || old.isDark != isDark;
}
