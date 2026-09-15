import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// SplashScreen — Ancient Letter-Opening & Revelation of Knowledge Animation
//
// 9-Step Cinematic Timeline (total controller duration: 3600 ms):
//   1. 0.00–0.16  Screen begins with warm parchment background & subtle vignette
//   2. 0.10–0.32  Single folded parchment letter drops gently from center-top
//   3. 0.30–0.44  Letter gently settles into place on the study desk
//   4. 0.42–0.58  Wax seal pulses with warm golden glow and cracks open
//   5. 0.54–0.78  Letter folds open naturally via 3D perspective, revealing inner paper
//   6. 0.66–0.86  Soft warm golden light blooms gently from the opening
//   7. 0.76–0.94  App emblem and "BAYAN: Quran & Science Research" appear in rich ink
//   8. 0.94–1.00  Letter rests open for a contemplative moment
//   9. +350 ms    Smooth cross-fade transition directly to the Home screen
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Timer? _navTimer;

  // ── Step 1: Background & framing fade-in ─────────────────────────────────
  late final Animation<double> _bgFade;

  // ── Step 2: Letter drop & fade-in ─────────────────────────────────────────
  late final Animation<Offset> _letterDrop;
  late final Animation<double> _letterFade;

  // ── Step 3: Gentle natural settle bob ─────────────────────────────────────
  late final Animation<double> _letterSettle;

  // ── Step 4: Seal warm glow & crack ───────────────────────────────────────
  late final Animation<double> _sealGlow;
  late final Animation<double> _sealCrack;

  // ── Step 5: Letter 3D unfolding ──────────────────────────────────────────
  late final Animation<double> _unfoldProgress;

  // ── Step 6: Inner golden revelation light bloom ──────────────────────────
  late final Animation<double> _lightBloom;

  // ── Step 7: App branding reveal ──────────────────────────────────────────
  late final Animation<double> _brandFade;
  late final Animation<Offset> _brandSlide;

  // ── Step 9: Final exit fade to Home ──────────────────────────────────────
  late final Animation<double> _exitFade;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    // Helper for interval curved animations (no leading underscores)
    Animation<double> curved(double start, double end, Curve curve) =>
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, end, curve: curve),
        );

    // Step 1: Background fade-in
    _bgFade = curved(0.0, 0.16, Curves.easeIn);

    // Step 2: Folded letter drop & appearance
    _letterDrop = Tween<Offset>(
      begin: const Offset(0, -0.16),
      end: Offset.zero,
    ).animate(curved(0.10, 0.32, Curves.easeOutCubic));

    _letterFade = curved(0.10, 0.24, Curves.easeIn);

    // Step 3: Gentle settle bob
    _letterSettle = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.30, 0.44, curve: _SettleCurve()),
      ),
    );

    // Step 4: Seal glow & opening crack
    _sealGlow = curved(0.40, 0.56, Curves.easeInOut);
    _sealCrack = curved(0.52, 0.62, Curves.easeInOut);

    // Step 5: Letter unfolding in 3D perspective
    _unfoldProgress = curved(0.54, 0.78, Curves.easeInOutCubic);

    // Step 6: Soft golden light bloom
    _lightBloom = curved(0.66, 0.86, Curves.easeOut);

    // Step 7: Branding fade and slide
    _brandFade = curved(0.76, 0.94, Curves.easeIn);
    _brandSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(curved(0.76, 0.94, Curves.easeOutCubic));

    // Step 9: Exit fade veil at end of animation
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      curved(0.96, 1.0, Curves.easeIn),
    );

    // Start playback & direct navigation to Home (bypassing onboarding completely)
    _ctrl.forward().then((_) {
      if (!mounted || _navigated) return;
      _navigated = true;
      _navTimer = Timer(const Duration(milliseconds: 350), () {
        if (mounted) context.go('/home');
      });
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    // Authentic manuscript palette that adapts gracefully to Dark Mode
    final bgColor = isDark ? const Color(0xFF171310) : const Color(0xFFFBF7EE);
    final vignetteCenter = isDark ? const Color(0xFF241D17) : const Color(0xFFFFFDF8);
    final vignetteEdge = isDark ? const Color(0xFF100D0B) : const Color(0xFFECE2CE);

    final paperColor = isDark ? const Color(0xFF261E18) : const Color(0xFFFFFDF9);
    final paperFlapColor = isDark ? const Color(0xFF2D231B) : const Color(0xFFF7F2E6);
    final paperShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.65)
        : const Color(0xFF6E5648).withValues(alpha: 0.22);

    final inkColor = isDark ? const Color(0xFFE8DECF) : const Color(0xFF2C211D);
    final sealColor = isDark ? const Color(0xFF8A293E) : AppColors.primaryMaroon;
    final goldTone = isDark ? AppColors.accentGoldLight : AppColors.accentGold;

    // Responsive manuscript width capped to authentic letter proportions
    final letterWidth = math.min(size.width * 0.82, 320.0);

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Layer 1: Warm parchment background with subtle vignette ────
              Opacity(
                opacity: _bgFade.value,
                child: _ParchmentBackground(
                  isDark: isDark,
                  bgColor: bgColor,
                  vignetteCenter: vignetteCenter,
                  vignetteEdge: vignetteEdge,
                ),
              ),

              // ── Layer 2: The Letter Manuscript Object in center ────────────
              Center(
                child: Opacity(
                  opacity: _letterFade.value,
                  child: SlideTransition(
                    position: _letterDrop,
                    child: Transform.scale(
                      scale: _letterSettle.value,
                      child: SizedBox(
                        width: letterWidth,
                        child: _AncientLetterWidget(
                          unfoldProgress: _unfoldProgress.value,
                          sealGlow: _sealGlow.value,
                          sealCrack: _sealCrack.value,
                          lightBloom: _lightBloom.value,
                          brandFade: _brandFade.value,
                          brandSlide: _brandSlide.value,
                          isDark: isDark,
                          paperColor: paperColor,
                          paperFlapColor: paperFlapColor,
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

              // ── Layer 3: Smooth exit fade to Home ─────────────────────────
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

// ── Subtle natural settle bob curve ──────────────────────────────────────────
class _SettleCurve extends Curve {
  const _SettleCurve();
  @override
  double transformInternal(double t) {
    // Gentle natural spring settle: bobs up slightly by 2.2% then rests
    return 1.0 + 0.022 * math.sin(t * math.pi);
  }
}

// ── Layer 1: Parchment background with delicate Islamic geometric border ─────
class _ParchmentBackground extends StatelessWidget {
  final bool isDark;
  final Color bgColor;
  final Color vignetteCenter;
  final Color vignetteEdge;

  const _ParchmentBackground({
    required this.isDark,
    required this.bgColor,
    required this.vignetteCenter,
    required this.vignetteEdge,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.50)
        : AppColors.parchmentBorder.withValues(alpha: 0.65);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        gradient: RadialGradient(
          center: const Alignment(0, -0.05),
          radius: 1.15,
          colors: [
            vignetteCenter,
            vignetteEdge,
          ],
        ),
      ),
      child: CustomPaint(
        painter: _ParchmentBorderPainter(
          isDark: isDark,
          borderColor: borderColor,
        ),
      ),
    );
  }
}

// Custom painter for classical Islamic geometric framing & delicate grain
class _ParchmentBorderPainter extends CustomPainter {
  final bool isDark;
  final Color borderColor;

  const _ParchmentBorderPainter({
    required this.isDark,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final innerBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: isDark ? 0.28 : 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Outer primary border — inset 26px
    const m = 26.0;
    final outerRect = Rect.fromLTWH(m, m, size.width - m * 2, size.height - m * 2);
    canvas.drawRRect(RRect.fromRectAndRadius(outerRect, const Radius.circular(3)), borderPaint);

    // Inner secondary thin rule — inset 31px
    const m2 = 31.0;
    final innerRect = Rect.fromLTWH(m2, m2, size.width - m2 * 2, size.height - m2 * 2);
    canvas.drawRRect(RRect.fromRectAndRadius(innerRect, const Radius.circular(2)), innerBorderPaint);

    // 8-Pointed Star Rosettes in four corners
    _drawCornerStar(canvas, Offset(m, m), 6.0, borderColor);
    _drawCornerStar(canvas, Offset(size.width - m, m), 6.0, borderColor);
    _drawCornerStar(canvas, Offset(m, size.height - m), 6.0, borderColor);
    _drawCornerStar(canvas, Offset(size.width - m, size.height - m), 6.0, borderColor);

    // Subtle horizontal parchment grain watermark lines
    final grainPaint = Paint()
      ..color = borderColor.withValues(alpha: isDark ? 0.05 : 0.04)
      ..strokeWidth = 0.5;

    for (double y = 70; y < size.height - 70; y += 24) {
      canvas.drawLine(
        Offset(m + 14, y),
        Offset(size.width - m - 14, y),
        grainPaint,
      );
    }
  }

  void _drawCornerStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

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

    // Center micro dot
    canvas.drawCircle(center, 1.0, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_ParchmentBorderPainter old) =>
      old.isDark != isDark || old.borderColor != borderColor;
}

// ── Layer 2: The Ancient Folded Letter Manuscript ────────────────────────────
class _AncientLetterWidget extends StatelessWidget {
  final double unfoldProgress; // 0.0 = completely folded, 1.0 = fully open
  final double sealGlow;       // 0.0 → 1.0 warm glow pulse
  final double sealCrack;      // 0.0 → 1.0 seal separation
  final double lightBloom;     // 0.0 → 1.0 golden illumination
  final double brandFade;      // 0.0 → 1.0 ink reveal
  final Offset brandSlide;
  final bool isDark;
  final Color paperColor;
  final Color paperFlapColor;
  final Color paperShadowColor;
  final Color inkColor;
  final Color sealColor;
  final Color goldTone;

  const _AncientLetterWidget({
    required this.unfoldProgress,
    required this.sealGlow,
    required this.sealCrack,
    required this.lightBloom,
    required this.brandFade,
    required this.brandSlide,
    required this.isDark,
    required this.paperColor,
    required this.paperFlapColor,
    required this.paperShadowColor,
    required this.inkColor,
    required this.sealColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    // Proportions: Height naturally expands subtly as letter unfolds (from 230 to 270)
    final letterHeight = 230.0 + (unfoldProgress * 40.0);

    return SizedBox(
      height: letterHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Base Manuscript Sheet (Inner parchment revealed upon opening) ──
          Positioned.fill(
            child: _ManuscriptBody(
              paperColor: paperColor,
              paperShadowColor: paperShadowColor,
              inkColor: inkColor,
              isDark: isDark,
              goldTone: goldTone,
            ),
          ),

          // ── Inner Manuscript Content & Warm Light Bloom ──────────────────
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Opacity(
                opacity: (unfoldProgress * 2.0).clamp(0.0, 1.0),
                child: _InnerManuscriptContent(
                  lightBloom: lightBloom,
                  brandFade: brandFade,
                  brandSlide: brandSlide,
                  isDark: isDark,
                  inkColor: inkColor,
                  goldTone: goldTone,
                ),
              ),
            ),
          ),

          // ── Bottom Letter Fold (Subtle lower envelope crease) ─────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: letterHeight * 0.42,
            child: Opacity(
              opacity: (1.0 - (unfoldProgress * 1.5)).clamp(0.0, 1.0),
              child: _BottomLetterFold(
                paperFlapColor: paperFlapColor,
                inkColor: inkColor,
                isDark: isDark,
              ),
            ),
          ),

          // ── Top Letter Flap (Folds open backwards in 3D perspective) ──────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopLetterFlap(
              progress: unfoldProgress,
              flapHeight: letterHeight * 0.52,
              paperFlapColor: paperFlapColor,
              inkColor: inkColor,
              isDark: isDark,
            ),
          ),

          // ── Center Wax Seal ──────────────────────────────────────────────
          Positioned(
            top: (letterHeight * 0.50) - 26.0,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: (1.0 - (sealCrack * 1.2)).clamp(0.0, 1.0),
                child: _WaxSeal(
                  glow: sealGlow,
                  sealColor: sealColor,
                  goldTone: goldTone,
                  unfoldProgress: unfoldProgress,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Base Manuscript Sheet: Aged parchment paper with authentic shadows ──────
class _ManuscriptBody extends StatelessWidget {
  final Color paperColor;
  final Color paperShadowColor;
  final Color inkColor;
  final bool isDark;
  final Color goldTone;

  const _ManuscriptBody({
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
          color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
          width: 1.1,
        ),
        boxShadow: [
          // Soft layered natural shadows giving antique depth
          BoxShadow(
            color: paperShadowColor,
            blurRadius: 36,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: paperShadowColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ManuscriptCreasePainter(inkColor: inkColor, isDark: isDark),
      ),
    );
  }
}

// Draws subtle historical letter crease guidelines and deckle frame
class _ManuscriptCreasePainter extends CustomPainter {
  final Color inkColor;
  final bool isDark;

  const _ManuscriptCreasePainter({
    required this.inkColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final creasePaint = Paint()
      ..color = inkColor.withValues(alpha: isDark ? 0.07 : 0.05)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Horizontal fold memory creases (where paper was historically pressed)
    final h1 = size.height * 0.33;
    final h2 = size.height * 0.67;
    canvas.drawLine(Offset(8, h1), Offset(size.width - 8, h1), creasePaint);
    canvas.drawLine(Offset(8, h2), Offset(size.width - 8, h2), creasePaint);

    // Delicate inner margin rule
    const inset = 12.0;
    final marginRect = Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2);
    final marginPaint = Paint()
      ..color = inkColor.withValues(alpha: isDark ? 0.06 : 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(RRect.fromRectAndRadius(marginRect, const Radius.circular(3)), marginPaint);
  }

  @override
  bool shouldRepaint(_ManuscriptCreasePainter old) =>
      old.inkColor != inkColor || old.isDark != isDark;
}

// ── Top Letter Flap: Folds open backwards in 3D perspective ──────────────────
class _TopLetterFlap extends StatelessWidget {
  final double progress; // 0.0 = closed (folded down), 1.0 = folded back up
  final double flapHeight;
  final Color paperFlapColor;
  final Color inkColor;
  final bool isDark;

  const _TopLetterFlap({
    required this.progress,
    required this.flapHeight,
    required this.paperFlapColor,
    required this.inkColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // 3D Perspective fold: rotates around top edge along the X-axis
    // progress 0.0 → angle 0.0 (pointing down, covering top half)
    // progress 1.0 → angle -π (fully swung back and open)
    final angle = -progress * math.pi;

    // If completely folded back (past 90°), hide to avoid z-fighting
    if (progress >= 0.98) return const SizedBox.shrink();

    return SizedBox(
      height: flapHeight,
      child: Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0014) // authentic subtle perspective
          ..rotateX(angle),
        child: ClipPath(
          clipper: _ManuscriptFlapClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: paperFlapColor,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                  width: 0.9,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _FlapDecklePainter(inkColor: inkColor, isDark: isDark),
            ),
          ),
        ),
      ),
    );
  }
}

// Antique parchment envelope flap: wide trapezoidal / soft triangular fold
class _ManuscriptFlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    // Subtle trapezoid fold taper down to center point
    path.lineTo(size.width * 0.92, size.height * 0.35);
    path.lineTo(size.width * 0.50, size.height);
    path.lineTo(size.width * 0.08, size.height * 0.35);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_ManuscriptFlapClipper old) => false;
}

class _FlapDecklePainter extends CustomPainter {
  final Color inkColor;
  final bool isDark;

  const _FlapDecklePainter({required this.inkColor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = inkColor.withValues(alpha: isDark ? 0.09 : 0.06)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    // Subtle spine crease line
    canvas.drawLine(
      Offset(size.width * 0.50, 0),
      Offset(size.width * 0.50, size.height * 0.75),
      paint,
    );
  }

  @override
  bool shouldRepaint(_FlapDecklePainter old) => false;
}

// ── Bottom Letter Fold: Gentle lower envelope fold ───────────────────────────
class _BottomLetterFold extends StatelessWidget {
  final Color paperFlapColor;
  final Color inkColor;
  final bool isDark;

  const _BottomLetterFold({
    required this.paperFlapColor,
    required this.inkColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomFoldClipper(),
      child: Container(
        color: paperFlapColor.withValues(alpha: 0.95),
        child: CustomPaint(
          painter: _BottomFoldLinePainter(inkColor: inkColor, isDark: isDark),
        ),
      ),
    );
  }
}

class _BottomFoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.88, size.height * 0.45);
    path.lineTo(size.width * 0.50, 0);
    path.lineTo(size.width * 0.12, size.height * 0.45);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_BottomFoldClipper old) => false;
}

class _BottomFoldLinePainter extends CustomPainter {
  final Color inkColor;
  final bool isDark;

  const _BottomFoldLinePainter({required this.inkColor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = inkColor.withValues(alpha: isDark ? 0.08 : 0.05)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    final midX = size.width * 0.5;
    canvas.drawLine(Offset(0, size.height), Offset(midX, size.height * 0.35), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(midX, size.height * 0.35), paint);
  }

  @override
  bool shouldRepaint(_BottomFoldLinePainter old) => false;
}

// ── Wax Seal: Antique stamped seal with 8-pointed Islamic Star ───────────────
class _WaxSeal extends StatelessWidget {
  final double glow;
  final double unfoldProgress;
  final Color sealColor;
  final Color goldTone;

  const _WaxSeal({
    required this.glow,
    required this.unfoldProgress,
    required this.sealColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    // Seal gently lifts slightly as flap begins opening
    final offsetY = unfoldProgress * (-16.0);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.25, -0.30),
            colors: [
              sealColor.withValues(alpha: 0.95),
              sealColor,
              Color.lerp(sealColor, Colors.black, 0.30)!,
            ],
            stops: const [0.0, 0.70, 1.0],
          ),
          boxShadow: [
            // Ambient warm golden glow pulse
            BoxShadow(
              color: goldTone.withValues(alpha: 0.25 + (glow * 0.45)),
              blurRadius: 10.0 + (glow * 18.0),
              spreadRadius: glow * 5.0,
            ),
            // Wax physical drop shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.40),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CustomPaint(
            size: const Size(30, 30),
            painter: _WaxSealStarPainter(goldTone: goldTone, glow: glow),
          ),
        ),
      ),
    );
  }
}

// 8-Pointed Islamic Star (Khatam) seal imprint
class _WaxSealStarPainter extends CustomPainter {
  final Color goldTone;
  final double glow;

  const _WaxSealStarPainter({required this.goldTone, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width * 0.45;
    final innerR = size.width * 0.22;
    const points = 8;

    final starPaint = Paint()
      ..color = goldTone.withValues(alpha: 0.65 + (glow * 0.30))
      ..style = PaintingStyle.fill;

    final starPath = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (i * math.pi) / points - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? starPath.moveTo(x, y) : starPath.lineTo(x, y);
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);

    // Outer circular engraved ring
    final ringPaint = Paint()
      ..color = goldTone.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    canvas.drawCircle(Offset(cx, cy), size.width * 0.48, ringPaint);

    // Center illuminated focal dot
    final centerPaint = Paint()
      ..color = goldTone.withValues(alpha: 0.90)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), size.width * 0.08, centerPaint);
  }

  @override
  bool shouldRepaint(_WaxSealStarPainter old) =>
      old.glow != glow || old.goldTone != goldTone;
}

// ── Inner Manuscript Content & Warm Golden Revelation Bloom ──────────────────
class _InnerManuscriptContent extends StatelessWidget {
  final double lightBloom;
  final double brandFade;
  final Offset brandSlide;
  final bool isDark;
  final Color inkColor;
  final Color goldTone;

  const _InnerManuscriptContent({
    required this.lightBloom,
    required this.brandFade,
    required this.brandSlide,
    required this.isDark,
    required this.inkColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    // Gentle golden radiance representing the revelation of knowledge
    final warmGlow = isDark
        ? AppColors.accentGoldLight.withValues(alpha: lightBloom * 0.20)
        : AppColors.accentGold.withValues(alpha: lightBloom * 0.14);

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.15),
          radius: 0.90,
          colors: [
            warmGlow,
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Manuscript Header Ruling Line (Safe, bounded width) ───────────
          Opacity(
            opacity: (brandFade * 0.45).clamp(0.0, 0.45),
            child: SizedBox(
              width: 200,
              child: _ManuscriptRulingLines(
                inkColor: inkColor,
                isDark: isDark,
                lineCount: 2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── App Emblem & Brand Name (Revealed naturally in dark ink) ───────
          Opacity(
            opacity: brandFade,
            child: Transform.translate(
              offset: Offset(brandSlide.dx * 20, brandSlide.dy * 20),
              child: _BrandRevealWidget(
                isDark: isDark,
                inkColor: inkColor,
                goldTone: goldTone,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Manuscript Footer Ruling Line ─────────────────────────────────
          Opacity(
            opacity: (brandFade * 0.40).clamp(0.0, 0.40),
            child: SizedBox(
              width: 160,
              child: _ManuscriptRulingLines(
                inkColor: inkColor,
                isDark: isDark,
                lineCount: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Classical manuscript horizontal ruling guidelines ("mastarah")
class _ManuscriptRulingLines extends StatelessWidget {
  final Color inkColor;
  final bool isDark;
  final int lineCount;

  const _ManuscriptRulingLines({
    required this.inkColor,
    required this.isDark,
    this.lineCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lineCount, (i) {
        final lineFraction = (i == 0) ? 1.0 : 0.72;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * lineFraction,
                  height: 0.9,
                  decoration: BoxDecoration(
                    color: inkColor.withValues(alpha: isDark ? 0.16 : 0.11),
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

// ── App Branding: Existing Logo & Name presented in authentic manuscript style ──
class _BrandRevealWidget extends StatelessWidget {
  final bool isDark;
  final Color inkColor;
  final Color goldTone;

  const _BrandRevealWidget({
    required this.isDark,
    required this.inkColor,
    required this.goldTone,
  });

  @override
  Widget build(BuildContext context) {
    final headingColor = isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Emblem Medallion ───────────────────────────────────────────────
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.darkSurfaceSubtle
                : AppColors.parchmentSubtle,
            border: Border.all(
              color: goldTone.withValues(alpha: 0.75),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: goldTone.withValues(alpha: 0.22),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Knowledge & Revelation Radiance
              Icon(
                Icons.auto_awesome,
                size: 30,
                color: goldTone,
              ),
              // Empirical Research / Science Inquest Motif
              Icon(
                Icons.science_outlined,
                size: 16,
                color: isDark ? AppColors.darkTextPrimary : inkColor,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ── Existing App Title: BAYAN ───────────────────────────────────────
        Text(
          'BAYAN',
          style: GoogleFonts.ebGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 4.8,
            color: headingColor,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 3),

        // ── Existing Subtitle: Quran & Science Research ───────────────────
        Text(
          'Quran & Science Research',
          style: GoogleFonts.ebGaramond(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 6),

        // ── Classical Gold Manuscript Rule & Miniature Diamond ─────────────
        SizedBox(
          width: 70,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.8,
                  color: goldTone.withValues(alpha: 0.45),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    color: goldTone.withValues(alpha: 0.65),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 0.8,
                  color: goldTone.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
