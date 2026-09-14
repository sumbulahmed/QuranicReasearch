import 'package:flutter/material.dart';
import '../models/evidence_level.dart';
import '../constants/app_typography.dart';
import '../constants/app_dimensions.dart';

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
        horizontal: compact ? 8.0 : 12.0,
        vertical: compact ? 4.0 : 6.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.45 : 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            level.icon,
            size: compact ? 14.0 : 16.0,
            color: color,
          ),
          const SizedBox(width: 6.0),
          Text(
            level.label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: badgeContent,
      );
    }

    return Tooltip(
      message: level.subtitle,
      child: badgeContent,
    );
  }
}
