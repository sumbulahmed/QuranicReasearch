import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// An elegant animated water glass with physical fluid waves,
/// volume indicators for the 3 Sunnah sips, and smooth level transitions.
class AnimatedWaterGlass extends StatefulWidget {
  final double targetLevel; // 0.0 to 1.0
  final double width;
  final double height;
  final bool isBreathing;
  final String? statusLabel;

  const AnimatedWaterGlass({
    super.key,
    required this.targetLevel,
    this.width = 110,
    this.height = 190,
    this.isBreathing = false,
    this.statusLabel,
  });

  @override
  State<AnimatedWaterGlass> createState() => _AnimatedWaterGlassState();
}

class _AnimatedWaterGlassState extends State<AnimatedWaterGlass>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _levelController;
  late Animation<double> _levelAnimation;
  double _currentLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.targetLevel;

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _levelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _levelAnimation = Tween<double>(
      begin: _currentLevel,
      end: widget.targetLevel,
    ).animate(CurvedAnimation(
      parent: _levelController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void didUpdateWidget(covariant AnimatedWaterGlass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetLevel != widget.targetLevel) {
      _levelAnimation = Tween<double>(
        begin: _currentLevel,
        end: widget.targetLevel,
      ).animate(CurvedAnimation(
        parent: _levelController,
        curve: Curves.easeInOutCubic,
      ));
      _levelController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_waveController, _levelController]),
          builder: (context, child) {
            _currentLevel = _levelAnimation.value;
            return CustomPaint(
              size: Size(widget.width, widget.height),
              painter: _GlassPainter(
                wavePhase: _waveController.value * 2 * math.pi,
                waterLevel: _currentLevel,
                isDark: isDark,
                isBreathing: widget.isBreathing,
              ),
            );
          },
        ),
        if (widget.statusLabel != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.primaryMaroon.withValues(alpha: 0.2),
                width: 0.8,
              ),
            ),
            child: Text(
              widget.statusLabel!,
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _GlassPainter extends CustomPainter {
  final double wavePhase;
  final double waterLevel; // 0.0 to 1.0
  final bool isDark;
  final bool isBreathing;

  _GlassPainter({
    required this.wavePhase,
    required this.waterLevel,
    required this.isDark,
    required this.isBreathing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer tapered glass geometry
    final topMargin = 8.0;
    final bottomMargin = 12.0;
    final glassTopWidth = w * 0.88;
    final glassBottomWidth = w * 0.68;

    final glassTopLeft = Offset((w - glassTopWidth) / 2, topMargin);
    final glassTopRight = Offset((w + glassTopWidth) / 2, topMargin);
    final glassBottomLeft = Offset((w - glassBottomWidth) / 2, h - bottomMargin);
    final glassBottomRight = Offset((w + glassBottomWidth) / 2, h - bottomMargin);

    // 1. Draw glass background tint
    final glassPath = Path()
      ..moveTo(glassTopLeft.dx, glassTopLeft.dy)
      ..lineTo(glassTopRight.dx, glassTopRight.dy)
      ..lineTo(glassBottomRight.dx, glassBottomRight.dy)
      ..quadraticBezierTo(w / 2, h - bottomMargin + 8, glassBottomLeft.dx, glassBottomLeft.dy)
      ..close();

    final glassBackPaint = Paint()
      ..color = isDark
          ? const Color(0xFF1E2630).withValues(alpha: 0.35)
          : const Color(0xFFE8EEF5).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    canvas.drawPath(glassPath, glassBackPaint);

    // 2. Draw water with waves clipped inside glass
    canvas.save();
    canvas.clipPath(glassPath);

    if (waterLevel > 0.01) {
      final usableHeight = (h - bottomMargin) - topMargin - 16;
      final surfaceY = (h - bottomMargin) - (usableHeight * waterLevel.clamp(0.0, 1.0));

      final waterPath = Path();
      waterPath.moveTo(0, h);
      waterPath.lineTo(0, surfaceY);

      // Dynamic sine wave
      final waveAmplitude = waterLevel > 0.05 ? 3.5 : 1.0;
      for (double x = 0; x <= w; x += 3) {
        final y = surfaceY + math.sin(wavePhase + (x / w) * 2 * math.pi) * waveAmplitude;
        waterPath.lineTo(x, y);
      }

      waterPath.lineTo(w, h);
      waterPath.close();

      // Multi-stop gradient for pure, clear water
      final waterGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                const Color(0xFF287998).withValues(alpha: 0.85),
                const Color(0xFF154C62).withValues(alpha: 0.95),
              ]
            : [
                const Color(0xFF5AB6D8).withValues(alpha: 0.80),
                const Color(0xFF2384A8).withValues(alpha: 0.90),
              ],
      );

      final waterPaint = Paint()
        ..shader = waterGradient.createShader(Rect.fromLTWH(0, surfaceY, w, h - surfaceY))
        ..style = PaintingStyle.fill;
      canvas.drawPath(waterPath, waterPaint);

      // Water surface highlight
      final waveHighlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: isDark ? 0.4 : 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final waveLinePath = Path();
      for (double x = glassTopLeft.dx + 4; x <= glassTopRight.dx - 4; x += 3) {
        final y = surfaceY + math.sin(wavePhase + (x / w) * 2 * math.pi) * waveAmplitude;
        if (x == glassTopLeft.dx + 4) {
          waveLinePath.moveTo(x, y);
        } else {
          waveLinePath.lineTo(x, y);
        }
      }
      canvas.drawPath(waveLinePath, waveHighlightPaint);

      // Bubbles
      final bubblePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      final b1Y = surfaceY + (h - surfaceY) * 0.4 + math.sin(wavePhase * 1.5) * 4;
      final b2Y = surfaceY + (h - surfaceY) * 0.7 + math.cos(wavePhase * 1.8) * 3;
      canvas.drawCircle(Offset(w * 0.38, b1Y), 2.5, bubblePaint);
      canvas.drawCircle(Offset(w * 0.62, b2Y), 2.0, bubblePaint);
    }

    // 3. Draw glass rim highlight reflection
    final glassShinePaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.15 : 0.4)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(glassTopLeft.dx + 6, glassTopLeft.dy + 8),
      Offset(glassBottomLeft.dx + 6, glassBottomLeft.dy - 6),
      glassShinePaint,
    );

    canvas.restore();

    // 4. Draw outer glass rim & outline
    final outlinePaint = Paint()
      ..color = isDark
          ? AppColors.darkBorder
          : AppColors.primaryMaroon.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(glassPath, outlinePaint);

    // Thick base of tumbler
    final basePaint = Paint()
      ..color = (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
          .withValues(alpha: 0.3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(glassBottomLeft.dx + 2, glassBottomLeft.dy + 2),
      Offset(glassBottomRight.dx - 2, glassBottomRight.dy + 2),
      basePaint,
    );

    // 5. Sunnah Sip Graduation Markers on right side
    final markerPaint = Paint()
      ..color = (isDark ? AppColors.accentGoldLight : AppColors.accentSepia)
          .withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    final usableH = (h - bottomMargin) - topMargin - 16;
    // 33% (Sip 2), 67% (Sip 1), 100%
    final levels = [0.33, 0.67];
    for (final lvl in levels) {
      final y = (h - bottomMargin) - (usableH * lvl);
      final rx = (w + glassTopWidth) / 2 - 3;
      canvas.drawLine(Offset(rx - 7, y), Offset(rx, y), markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlassPainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase ||
        oldDelegate.waterLevel != waterLevel ||
        oldDelegate.isDark != isDark ||
        oldDelegate.isBreathing != isBreathing;
  }
}
