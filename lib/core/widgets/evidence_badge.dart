import 'package:flutter/material.dart';
import '../models/evidence_level.dart';
import '../constants/app_typography.dart';
import '../constants/app_dimensions.dart';

/// Refined scholarly seal badge indicating the peer-reviewed evidence status.
class EvidenceBadge extends StatelessWidget {
  final EvidenceLevel level;
  final bool compact;
  final VoidCallback? onTap;

  const EvidenceBadge({
    super.key,
    required this.level,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = level.color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8.0 : 11.0,
        vertical: compact ? 3.0 : 5.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.22 : 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.5 : 0.4),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            level.icon,
            size: compact ? 13.0 : 15.0,
            color: color,
          ),
          const SizedBox(width: 5.0),
          Text(
            level.label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 10.5 : 11.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: badgeContent,
      );
    }

    return Tooltip(
      message: level.subtitle,
      child: badgeContent,
    );
  }
}
