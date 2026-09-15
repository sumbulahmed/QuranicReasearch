import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// SplashScreen — Letter-opening revelation animation
//
// Animation timeline (total duration: 3800 ms):
//   0.00–0.12  Background fades in (parchment warm tone)
//   0.12–0.30  Folded letter drops in from center-top and settles
//   0.30–0.52  Letter gently rocks/settles (ease-out)
//   0.52–0.68  Seal glow pulses then cracks open
//   0.68–0.84  Top flap folds back, revealing inner paper
//   0.84–0.92  Warm golden light blooms from inside the letter
//   0.92–1.00  App logo + name fade in on the open letter
//
// After the controller completes, a brief 600 ms hold then context.go('/home').
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // ── Phase 1: background fade-in ──────────────────────────────────────────
  late final Animation<double> _bgFade;

  // ── Phase 2: letter drop & settle ────────────────────────────────────────
  late final Animation<Offset> _letterDrop;
  late final Animation<double> _letterFade;

  // ── Phase 3: subtle settle bob ────────────────────────────────────────────
  late final Animation<double> _letterSettle; // slight scale pulse

  // ── Phase 4: seal glow ───────────────────────────────────────────────────
  late final Animation<double> _sealGlow;
  late final Animation<double> _sealCrack; // seal opacity out

  // ── Phase 5: flap opening ────────────────────────────────────────────────
  late final Animation<double> _flapOpen; // 0→1, drives rotateX on top flap

  // ── Phase 6: inner light bloom ───────────────────────────────────────────
  late final Animation<double> _lightBloom;

  // ── Phase 7: branding reveal ─────────────────────────────────────────────
  late final Animation<double> _brandFade;
  late final Animation<Offset> _brandSlide;

  // ── Phase 8: whole-screen fade-out to home ───────────────────────────────
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    // ── Helpers ──────────────────────────────────────────────────────────
    Animation<double> _curved(double start, double end, Curve curve) =>
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, end, curve: curve),
        );

    // ── Phase 1 ──────────────────────────────────────────────────────────
    _bgFade = _curved(0.0, 0.18, Curves.easeIn);

    // ── Phase 2 ──────────────────────────────────────────────────────────
    _letterDrop = Tween<Offset>(
      begin: const Offset(0, -0.18),
      end: Offset.zero,
    ).animate(_curved(0.12, 0.38, Curves.easeOutCubic));

    _letterFade = _curved(0.12, 0.28, Curves.easeIn);

    // ── Phase 3 ──────────────────────────────────────────────────────────
    _letterSettle = Tween<double>(begin: 1.0, end: 1.0).animate(
      // We'll use a custom curve that bobs and returns to 1.0
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.38, 0.54, curve: _SettleCurve()),
      ),
    );

    // ── Phase 4 ──────────────────────────────────────────────────────────
    _sealGlow = _curved(0.44, 0.62, Curves.easeInOut);
    _sealCrack = _curved(0.58, 0.68, Curves.easeIn);

    // ── Phase 5 ──────────────────────────────────────────────────────────
    _flapOpen = _curved(0.64, 0.84, Curves.easeInOutCubic);

    // ── Phase 6 ──────────────────────────────────────────────────────────
    _lightBloom = _curved(0.78, 0.92, Curves.easeOut);

    // ── Phase 7 ──────────────────────────────────────────────────────────
    _brandFade = _curved(0.88, 1.0, Curves.easeIn);
    _brandSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(_curved(0.88, 1.0, Curves.easeOutCubic));

    // ── Phase 8: exit fade — runs after controller finishes ──────────────
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.96, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start & navigate
    _ctrl.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 520), () {
        if (mounted) context.go('/home');
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    // Parchment tones adapt slightly for dark mode (still warm, just dimmed)
    final bgColor =
        isDark ? const Color(0xFF1A1512) : AppColors.parchment;
    final paperColor =
        isDark ? const Color(0xFF2A2118) : AppColors.parchmentCard;
    final paperShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : AppColors.accentSepia.withValues(alpha: 0.18);
    final inkColor =
        isDark ? AppColors.parchmentDarker : AppColors.lightTextPrimary;
    final sealColor =
        isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon;
    final goldTone =
        isDark ? AppColors.accentGoldLight : AppColors.accentGold;

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              // ── Layer 1: Warm parchment background ───────────────────────
              Opacity(
                opacity: _bgFade.value,
                child: _ParchmentBackground(
                  isDark: isDark,
                  bgColor: bgColor,
                ),
              ),

              // ── Layer 2: Letter assembly ──────────────────────────────────
              Center(
                child: Opacity(
                  opacity: _letterFade.value,
                  child: SlideTransition(
                    position: _letterDrop,
                    child: Transform.scale(
                      scale: _letterSettle.value,
                      child: SizedBox(
                        width: math.min(size.width * 0.72, 310),
                        child: _LetterWidget(
                          flapProgress: _flapOpen.value,
                          sealGlow: _sealGlow.value,
                          sealCrack: _sealCrack.value,
                          lightBloom: _lightBloom.value,
                          brandFade: _brandFade.value,
                          brandSlide: _brandSlide.value,
                          isDark: isDark,
                          paperColor: paperColor,
                          paperShadowColor: paperShadowColor,
                          inkColor: inkColor,
                          sealColor: sealColor,
                          goldTone: goldTone,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Layer 3: Exit fade-out veil ───────────────────────────────
              if (_exitFade.value < 1.0)
                Opacity(
                  opacity: 1.0 - _exitFade.value,
                  child: Container(color: bgColor),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ── Subtle settle curve: slight overshoot then returns to 1.0 ────────────────
class _SettleCurve extends Curve {
  const _SettleCurve();
  @override
  double transformInternal(double t) {
    // Quick bob: goes to 1.03 at t=0.4 then back to 1.0
    return 1.0 + 0.028 * math.sin(t * math.pi);
  }
}

// ── Parchment background with subtle warm grain ornament ─────────────────────
class _ParchmentBackground extends StatelessWidget {
  final bool isDark;
  final Color bgColor;
  const _ParchmentBackground({required this.isDark, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.6)
        : AppColors.parchmentBorder.withValues(alpha: 0.7);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: CustomPaint(
        painter: _ParchmentGrainPainter(isDark: isDark, borderColor: borderColor),
      ),
    );
  }
}

class _ParchmentGrainPainter extends CustomPainter {
  final bool isDark;
  final Color borderColor;
  const _ParchmentGrainPainter(
      {required this.isDark, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer decorative border — inset 28px
    const m = 28.0;
    final rect = Rect.fromLTWH(m, m, size.width - m * 2, size.height - m * 2);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);

    // Four corner floral ornaments drawn as simple cross/diamond shapes
    _drawCornerOrnament(canvas, paint, Offset(m, m));
    _drawCornerOrnament(canvas, paint, Offset(size.width - m, m));
    _drawCornerOrnament(canvas, paint, Offset(m, size.height - m));
    _drawCornerOrnament(canvas, paint, Offset(size.width - m, size.height - m));

    // Subtle horizontal grain lines (very faint)
    final grainPaint = Paint()
      ..color = borderColor.withValues(alpha: isDark ? 0.08 : 0.06)
      ..strokeWidth = 0.5;
    for (double y = 80; y < size.height - 80; y += 22) {
      canvas.drawLine(
        Offset(m + 10, y),
        Offset(size.width - m - 10, y),
        grainPaint,
      );
    }
  }

  void _drawCornerOrnament(Canvas canvas, Paint paint, Offset center) {
    const r = 5.0;
    // Small diamond
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    canvas.drawPath(path, paint);
    // Cross lines
    canvas.drawLine(
        Offset(center.dx - r * 2, center.dy),
        Offset(center.dx - r, center.dy),
        paint);
    canvas.drawLine(
        Offset(center.dx + r, center.dy),
        Offset(center.dx + r * 2, center.dy),
        paint);
    canvas.drawLine(
        Offset(center.dx, center.dy - r * 2),
        Offset(center.dx, center.dy - r),
        paint);
    canvas.drawLine(
        Offset(center.dx, center.dy + r),
        Offset(center.dx, center.dy + r * 2),
        paint);
  }

  @override
  bool shouldRepaint(_ParchmentGrainPainter old) =>
      old.isDark != isDark || old.borderColor != borderColor;
}

// ── The letter widget — envelope + flap + inner contents ─────────────────────
class _LetterWidget extends StatelessWidget {
  final double flapProgress;   // 0 = closed, 1 = fully open
  final double sealGlow;       // 0→1 seal glows
  final double sealCrack;      // 0→1 seal fades out (cracked)
  final double lightBloom;     // 0→1 inner glow blooms
  final double brandFade;      // 0→1 branding appears
  final Offset brandSlide;
  final bool isDark;
  final Color paperColor;
  final Color paperShadowColor;
  final Color inkColor;
  final Color sealColor;
  final Color goldTone;

  const _LetterWidget({
    required this.flapProgress,
    required this.sealGlow,
    required this.sealCrack,
    required this.lightBloom,
    required this.brandFade,
    required this.brandSlide,
    required this.isDark,
    required this.paperColor,
    required this.paperShadowColor,
    required this.inkColor,
    required this.sealColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    // Letter proportions
    const double aspectRatio = 0.72; // width:height roughly A5-ish
    return AspectRatio(
      aspectRatio: 1 / aspectRatio,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Envelope body (back) ────────────────────────────────────────
          Positioned.fill(
            child: _EnvelopeBody(
              paperColor: paperColor,
              paperShadowColor: paperShadowColor,
              inkColor: inkColor,
              isDark: isDark,
              goldTone: goldTone,
            ),
          ),

          // ── Inner letter content — revealed as flap opens ───────────────
          Positioned.fill(
            child: ClipRect(
              child: Opacity(
                opacity: (flapProgress * 2.2).clamp(0.0, 1.0),
                child: _InnerLetterContent(
                  lightBloom: lightBloom,
                  brandFade: brandFade,
                  brandSlide: brandSlide,
                  isDark: isDark,
                  paperColor: paperColor,
                  inkColor: inkColor,
                  goldTone: goldTone,
                ),
              ),
            ),
          ),

          // ── Envelope flap (top fold) ─────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _EnvelopeFlap(
              progress: flapProgress,
              paperColor: paperColor,
              paperShadowColor: paperShadowColor,
              inkColor: inkColor,
              isDark: isDark,
            ),
          ),

          // ── Wax seal ────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: (1.0 - sealCrack).clamp(0.0, 1.0),
                child: _WaxSeal(
                  glow: sealGlow,
                  sealColor: sealColor,
                  goldTone: goldTone,
                  flapProgress: flapProgress,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Envelope body: the main parchment paper rectangle ────────────────────────
class _EnvelopeBody extends StatelessWidget {
  final Color paperColor;
  final Color paperShadowColor;
  final Color inkColor;
  final bool isDark;
  final Color goldTone;

  const _EnvelopeBody({
    required this.paperColor,
    required this.paperShadowColor,
    required this.inkColor,
    required this.isDark,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: paperColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.parchmentBorder,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: paperShadowColor,
            blurRadius: 32,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: paperShadowColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _EnvelopeLinePainter(inkColor: inkColor, isDark: isDark),
      ),
    );
  }
}

// Draws the classic envelope V-lines on the body
class _EnvelopeLinePainter extends CustomPainter {
  final Color inkColor;
  final bool isDark;
  const _EnvelopeLinePainter({required this.inkColor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = inkColor.withValues(alpha: isDark ? 0.10 : 0.07)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Bottom V crease lines
    final mid = size.width / 2;
    canvas.drawLine(Offset(0, size.height), Offset(mid, size.height * 0.58), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(mid, size.height * 0.58), paint);

    // Left & right diagonal fold marks
    canvas.drawLine(Offset(0, 0), Offset(mid, size.height * 0.58), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(mid, size.height * 0.58), paint);
  }

  @override
  bool shouldRepaint(_EnvelopeLinePainter old) =>
      old.inkColor != inkColor || old.isDark != isDark;
}

// ── Envelope flap: folds back via perspective transform ──────────────────────
class _EnvelopeFlap extends StatelessWidget {
  final double progress; // 0 = closed (pointing down), 1 = folded back up
  final Color paperColor;
  final Color paperShadowColor;
  final Color inkColor;
  final bool isDark;

  const _EnvelopeFlap({
    required this.progress,
    required this.paperColor,
    required this.paperShadowColor,
    required this.inkColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Flap height = 48% of total letter height, driven by AspectRatio above
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final flapH = constraints.maxHeight * 0.48;

      // Perspective fold: rotate around the top edge, X-axis
      // progress 0 → angle 0 (closed, pointing down into letter)
      // progress 1 → angle -π (fully folded back/up, revealing inside)
      final angle = progress * math.pi;

      return SizedBox(
        height: flapH,
        width: w,
        child: Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012) // perspective
            ..rotateX(angle),
          child: ClipPath(
            clipper: _FlapClipper(),
            child: Container(
              width: w,
              height: flapH,
              decoration: BoxDecoration(
                color: isDark
                    ? paperColor.withValues(alpha: 0.95)
                    : AppColors.parchmentSubtle,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
              ),
              child: CustomPaint(
                painter: _FlapLinePainter(inkColor: inkColor, isDark: isDark),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// Triangle clipper for the flap — classic envelope V-flap shape
class _FlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_FlapClipper old) => false;
}

class _FlapLinePainter extends CustomPainter {
  final Color inkColor;
  final bool isDark;
  const _FlapLinePainter({required this.inkColor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = inkColor.withValues(alpha: isDark ? 0.12 : 0.08)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    // Subtle crease line down the middle of the flap
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height * 0.55),
      paint,
    );
  }

  @override
  bool shouldRepaint(_FlapLinePainter old) => false;
}

// ── Wax seal ──────────────────────────────────────────────────────────────────
class _WaxSeal extends StatelessWidget {
  final double glow;
  final double flapProgress;
  final Color sealColor;
  final Color goldTone;

  const _WaxSeal({
    required this.glow,
    required this.flapProgress,
    required this.sealColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    // Seal rides on the flap — moves upward as flap opens
    final offsetY = flapProgress * (-18.0);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: sealColor,
          boxShadow: [
            BoxShadow(
              color: goldTone.withValues(alpha: 0.30 + glow * 0.45),
              blurRadius: 8 + glow * 20,
              spreadRadius: glow * 6,
            ),
          ],
        ),
        child: Center(
          child: CustomPaint(
            size: const Size(26, 26),
            painter: _SealStarPainter(goldTone: goldTone, glow: glow),
          ),
        ),
      ),
    );
  }
}

// Eight-pointed star on the seal (classic Islamic geometric motif)
class _SealStarPainter extends CustomPainter {
  final Color goldTone;
  final double glow;
  const _SealStarPainter({required this.goldTone, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width * 0.46;
    final innerR = size.width * 0.22;
    const points = 8;

    final paint = Paint()
      ..color = goldTone.withValues(alpha: 0.55 + glow * 0.35)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (i * math.pi) / points - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Small circle in the center
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.09,
      paint..color = goldTone.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_SealStarPainter old) =>
      old.glow != glow || old.goldTone != goldTone;
}

// ── Inner letter content — revealed when flap opens ──────────────────────────
class _InnerLetterContent extends StatelessWidget {
  final double lightBloom;
  final double brandFade;
  final Offset brandSlide;
  final bool isDark;
  final Color paperColor;
  final Color inkColor;
  final Color goldTone;

  const _InnerLetterContent({
    required this.lightBloom,
    required this.brandFade,
    required this.brandSlide,
    required this.isDark,
    required this.paperColor,
    required this.inkColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    final warmGlow = isDark
        ? AppColors.accentGoldLight.withValues(alpha: lightBloom * 0.18)
        : AppColors.accentGold.withValues(alpha: lightBloom * 0.12);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 0.85,
          colors: [
            warmGlow,
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 36, 18, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 28),

            // ── Decorative ink lines (simulate handwriting) ───────────────
            Opacity(
              opacity: (brandFade * 0.5).clamp(0.0, 0.5),
              child: _InkLines(inkColor: inkColor, isDark: isDark),
            ),

            const SizedBox(height: 16),

            // ── App logo + name ───────────────────────────────────────────
            Opacity(
              opacity: brandFade,
              child: Transform.translate(
                offset: Offset(
                  brandSlide.dx * 30,
                  brandSlide.dy * 30,
                ),
                child: _BrandContent(
                  isDark: isDark,
                  inkColor: inkColor,
                  goldTone: goldTone,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── More decorative lines below branding ──────────────────────
            Opacity(
              opacity: (brandFade * 0.4).clamp(0.0, 0.4),
              child: _InkLines(
                inkColor: inkColor,
                isDark: isDark,
                lineCount: 2,
                width: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simulated handwriting lines on the inner paper
class _InkLines extends StatelessWidget {
  final Color inkColor;
  final bool isDark;
  final int lineCount;
  final double width; // fraction of available width

  const _InkLines({
    required this.inkColor,
    required this.isDark,
    this.lineCount = 3,
    this.width = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(lineCount, (i) {
        final lineW = width * (i == 1 ? 0.7 : (i == 2 ? 0.85 : 0.95));
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.5),
          child: FractionallySizedBox(
            widthFactor: lineW,
            child: Container(
              height: 1.0,
              decoration: BoxDecoration(
                color: inkColor.withValues(alpha: isDark ? 0.18 : 0.13),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── App branding rendered on the open letter ─────────────────────────────────
class _BrandContent extends StatelessWidget {
  final bool isDark;
  final Color inkColor;
  final Color goldTone;

  const _BrandContent({
    required this.isDark,
    required this.inkColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    final headingColor =
        isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon;
    final subtitleColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo emblem ────────────────────────────────────────────────────
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.darkSurfaceSubtle
                : AppColors.parchmentSubtle,
            border: Border.all(
              color: goldTone.withValues(alpha: 0.65),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: goldTone.withValues(alpha: 0.20),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 34,
                color: goldTone,
              ),
              Icon(
                Icons.science_outlined,
                size: 17,
                color: isDark ? AppColors.darkTextPrimary : inkColor,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── App name ────────────────────────────────────────────────────────
        Text(
          'BAYAN',
          style: GoogleFonts.ebGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 5.0,
            color: headingColor,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 5),

        // ── Subtitle ────────────────────────────────────────────────────────
        Text(
          'Quran & Science Research',
          style: GoogleFonts.ebGaramond(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // ── Thin gold divider line ───────────────────────────────────────────
        Container(
          width: 60,
          height: 1.0,
          color: goldTone.withValues(alpha: 0.45),
        ),
      ],
    );
  }
}
