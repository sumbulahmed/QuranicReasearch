import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_card.dart';

/// Scientific anatomical diagram illustrating gravity-assisted bolus transit
/// and optimal laryngeal alignment in an upright posture.
class PostureSwallowingDiagram extends StatelessWidget {
  const PostureSwallowingDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  Icons.biotech_rounded,
                  size: 16,
                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Physiological Mechanics: Upright Posture',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextHeading : AppColors.lightTextHeading,
                      ),
                    ),
                    Text(
                      'Gravity-assisted esophageal clearance & airway protection',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Diagram Container
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 0.8,
              ),
            ),
            child: CustomPaint(
              painter: _SwallowingBiomechanicsPainter(isDark: isDark),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFeaturePill(
                icon: Icons.vertical_align_bottom_rounded,
                label: 'Gravity Flow',
                sub: 'Optimal esophageal entry',
                isDark: isDark,
              ),
              _buildFeaturePill(
                icon: Icons.shield_outlined,
                label: 'Laryngeal Seal',
                sub: 'Protected airway transit',
                isDark: isDark,
              ),
              _buildFeaturePill(
                icon: Icons.speed_rounded,
                label: 'Controlled Bolus',
                sub: 'Reduced aspiration index',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill({
    required IconData icon,
    required String label,
    required String sub,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
          ),
        ),
        Text(
          sub,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 9.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _SwallowingBiomechanicsPainter extends CustomPainter {
  final bool isDark;

  _SwallowingBiomechanicsPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    final primaryLine = Paint()
      ..color = (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
          .withValues(alpha: 0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashedLine = Paint()
      ..color = (isDark ? AppColors.darkBorder : AppColors.parchmentBorder)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final bolusPaint = Paint()
      ..color = const Color(0xFF287998)
      ..style = PaintingStyle.fill;

    // Upright Seated Profile Silhouette
    final profilePath = Path();
    final centerX = w * 0.45;

    // Head outline
    profilePath.moveTo(centerX - 25, 20);
    profilePath.quadraticBezierTo(centerX - 10, 15, centerX + 10, 25);
    profilePath.quadraticBezierTo(centerX + 25, 35, centerX + 20, 50); // Nose/Face
    profilePath.quadraticBezierTo(centerX + 25, 60, centerX + 10, 68); // Chin
    profilePath.lineTo(centerX + 6, 85); // Neck front

    // Back of head & spine
    profilePath.moveTo(centerX - 25, 20);
    profilePath.quadraticBezierTo(centerX - 40, 40, centerX - 30, 75);
    profilePath.lineTo(centerX - 30, 135); // Spine straight down (upright)

    canvas.drawPath(profilePath, primaryLine);

    // Pharynx / Esophagus digestive tract path
    final digestivePath = Path();
    digestivePath.moveTo(centerX + 8, 62); // Mouth
    digestivePath.quadraticBezierTo(centerX - 4, 75, centerX - 4, 135); // Esophagus down

    final tractPaint = Paint()
      ..color = (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
          .withValues(alpha: 0.25)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(digestivePath, tractPaint);

    // Bolus droplets moving down esophagus
    canvas.drawCircle(Offset(centerX + 2, 70), 3.5, bolusPaint);
    canvas.drawCircle(Offset(centerX - 4, 96), 4.5, bolusPaint);
    canvas.drawCircle(Offset(centerX - 4, 122), 4.0, bolusPaint);

    // Gravity Vector Arrow
    final arrowX = w * 0.80;
    canvas.drawLine(Offset(arrowX, 30), Offset(arrowX, 110), primaryLine);
    final arrowTip = Path()
      ..moveTo(arrowX - 5, 102)
      ..lineTo(arrowX, 112)
      ..lineTo(arrowX + 5, 102);
    canvas.drawPath(arrowTip, primaryLine);

    // Annotation text labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: 'Gravity',
      style: TextStyle(
        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(arrowX - 14, 116));

    // Larynx indicator
    canvas.drawCircle(
      Offset(centerX + 6, 82),
      2.5,
      Paint()..color = isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
    );
    canvas.drawLine(
      Offset(centerX + 8, 82),
      Offset(centerX + 35, 82),
      dashedLine,
    );
    textPainter.text = TextSpan(
      text: 'Airway Protection',
      style: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        fontSize: 9.5,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(centerX + 40, 76));
  }

  @override
  bool shouldRepaint(covariant _SwallowingBiomechanicsPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
