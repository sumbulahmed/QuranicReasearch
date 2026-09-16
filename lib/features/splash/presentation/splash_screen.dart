import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Single, consolidated Splash Screen for the application.
/// Clean, modern, and elegant presentation of the BAYAN branding with a fast,
/// fluid transition directly to the Home screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  Timer? _navTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();

    // Concise, elegant splash duration before navigating directly to /home
    _navTimer = Timer(const Duration(milliseconds: 1300), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (!mounted || _navigated) return;
    _navigated = true;
    context.go('/home');
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final headingColor = isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final goldTone = isDark ? AppColors.accentGoldLight : AppColors.accentGold;
    final borderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.50)
        : AppColors.parchmentBorder.withValues(alpha: 0.65);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle classical Islamic border framing
          CustomPaint(
            painter: _SplashBorderPainter(
              borderColor: borderColor,
              isDark: isDark,
            ),
          ),

          // Centered Brand Content with smooth fade and subtle scale
          Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Emblem Medallion
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.darkSurfaceSubtle
                          : AppColors.parchmentSubtle,
                      border: Border.all(
                        color: goldTone.withValues(alpha: 0.8),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: goldTone.withValues(alpha: 0.20),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 38,
                          color: goldTone,
                        ),
                        Icon(
                          Icons.science_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.primaryMaroon,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // App Title: BAYAN
                  Text(
                    'BAYAN',
                    style: GoogleFonts.ebGaramond(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 5.5,
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
                      letterSpacing: 1.5,
                      color: subtitleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Classical Gold Manuscript Rule & Miniature Diamond
                  SizedBox(
                    width: 90,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 0.9,
                            color: goldTone.withValues(alpha: 0.45),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 5,
                              height: 5,
                              color: goldTone.withValues(alpha: 0.70),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 0.9,
                            color: goldTone.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Modern minimal indicator
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        goldTone.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle classical Islamic border painter framing the splash screen
class _SplashBorderPainter extends CustomPainter {
  final Color borderColor;
  final bool isDark;

  const _SplashBorderPainter({
    required this.borderColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const m = 24.0;
    final rect = Rect.fromLTWH(m, m, size.width - m * 2, size.height - m * 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      borderPaint,
    );

    // Subtle 8-pointed star in each corner
    _drawStar(canvas, Offset(m, m), 5.0, borderColor);
    _drawStar(canvas, Offset(size.width - m, m), 5.0, borderColor);
    _drawStar(canvas, Offset(m, size.height - m), 5.0, borderColor);
    _drawStar(canvas, Offset(size.width - m, size.height - m), 5.0, borderColor);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
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
  bool shouldRepaint(_SplashBorderPainter old) =>
      old.borderColor != borderColor || old.isDark != isDark;
}
