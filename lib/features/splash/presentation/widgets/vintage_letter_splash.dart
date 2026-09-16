import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'animated_envelope.dart';
import 'letter_reveal_animation.dart';

/// Master orchestrator for the 10-step, 3.5-second cinematic vintage letter splash sequence.
/// Animates the sealed letter, wax seal break, flap unfolding, letter emergence,
/// warm illumination, and illuminated BAYAN brand reveal.
class VintageLetterSplash extends StatefulWidget {
  final VoidCallback onComplete;

  const VintageLetterSplash({
    super.key,
    required this.onComplete,
  });

  @override
  State<VintageLetterSplash> createState() => _VintageLetterSplashState();
}

class _VintageLetterSplashState extends State<VintageLetterSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Animation intervals mapped to the 10-stage choreography
  late final Animation<double> _appearanceFade;
  late final Animation<double> _appearanceScale;
  late final Animation<double> _sealFracture;
  late final Animation<double> _flapUnfold;
  late final Animation<double> _glowIntensity;
  late final Animation<double> _letterSlide;
  late final Animation<double> _letterUnfold;
  late final Animation<double> _brandReveal;
  late final Animation<double> _dissolveOut;

  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 1. Initial fade-in & settle in center (0 - 700ms)
    _appearanceFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
      ),
    );

    _appearanceScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.22, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Wax seal opens / fractures (700 - 1330ms)
    _sealFracture = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.38, curve: Curves.easeInOut),
      ),
    );

    // 3. Envelope flap unfolds upward (1190 - 2030ms)
    _flapUnfold = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.34, 0.58, curve: Curves.easeInOutCubic),
      ),
    );

    // 4. Warm radiant light bloom emerges (1330 - 2380ms)
    _glowIntensity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.65).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.68),
      ),
    );

    // 5. Letter emerges from envelope pocket (1680 - 2520ms)
    _letterSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.48, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    // 6. Letter unfolds sheet to full height (1890 - 2590ms)
    _letterUnfold = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.74, curve: Curves.easeOutCubic),
      ),
    );

    // 7. Brand emblem and ink calligraphy reveal (2275 - 2975ms)
    _brandReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );

    // 8. Soft dissolve directly into Home screen (3220 - 3500ms)
    _dissolveOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.92, 1.00, curve: Curves.easeInOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerComplete();
      }
    });

    _controller.forward();
  }

  void _triggerComplete() {
    if (!mounted || _hasCompleted) return;
    _hasCompleted = true;
    widget.onComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check reduced-motion preference
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion && !_hasCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerComplete());
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.darkBackground : AppColors.parchment;
    final borderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.45)
        : AppColors.parchmentBorder.withValues(alpha: 0.60);

    return GestureDetector(
      onTap: _triggerComplete, // Tap to skip directly to Home
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Subtle Paper Grain & Antique Ambient Lighting
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: isDark
                      ? [
                          const Color(0xFF241C1A),
                          const Color(0xFF1B1513),
                          AppColors.darkBackground,
                        ]
                      : [
                          const Color(0xFFFFFDF8),
                          const Color(0xFFFBF6EA),
                          const Color(0xFFF2E7D3),
                        ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            // 2. Minimal Islamic Geometric Framing Border
            CustomPaint(
              painter: _VintageFramePainter(
                borderColor: borderColor,
                isDark: isDark,
              ),
            ),

            // 3. Central Animated Letter & Envelope Composition
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final totalOpacity = (_appearanceFade.value * _dissolveOut.value).clamp(0.0, 1.0);
                  final scale = _appearanceScale.value;

                  return Opacity(
                    opacity: totalOpacity,
                    child: Transform.scale(
                      scale: scale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Inner Unfolding Letter (emerges behind front pocket, in front of back)
                          if (_letterSlide.value > 0.01)
                            LetterRevealAnimation(
                              slideProgress: _letterSlide.value,
                              unfoldProgress: _letterUnfold.value,
                              glowIntensity: _glowIntensity.value,
                              brandProgress: _brandReveal.value,
                              isDark: isDark,
                            ),

                          // Envelope Front Pocket & Flap (draws on top of lower letter half)
                          AnimatedEnvelope(
                            flapProgress: _flapUnfold.value,
                            sealBreakProgress: _sealFracture.value,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal Islamic geometric corner framing with subtle 8-pointed stars.
class _VintageFramePainter extends CustomPainter {
  final Color borderColor;
  final bool isDark;

  const _VintageFramePainter({
    required this.borderColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const m = 22.0;
    final rect = Rect.fromLTWH(m, m, size.width - m * 2, size.height - m * 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      borderPaint,
    );

    // Subtle 8-pointed star in each corner
    _drawCornerStar(canvas, Offset(m, m), 4.5, borderColor);
    _drawCornerStar(canvas, Offset(size.width - m, m), 4.5, borderColor);
    _drawCornerStar(canvas, Offset(m, size.height - m), 4.5, borderColor);
    _drawCornerStar(canvas, Offset(size.width - m, size.height - m), 4.5, borderColor);
  }

  void _drawCornerStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    const points = 8;
    final outerR = radius;
    final innerR = radius * 0.45;
    final path = Path();

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (i * math.pi) / points - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_VintageFramePainter old) =>
      old.borderColor != borderColor || old.isDark != isDark;
}
