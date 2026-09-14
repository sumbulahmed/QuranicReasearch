import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Classic literary manuscript divider with optional ornamental diamond florilegium.
class CustomDivider extends StatelessWidget {
  final bool showOrnament;
  final double verticalPadding;
  final Color? color;

  const CustomDivider({
    super.key,
    this.showOrnament = false,
    this.verticalPadding = 16.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = color ?? (isDark ? AppColors.darkBorder : AppColors.parchmentBorder);

    if (!showOrnament) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Divider(
          color: dividerColor,
          thickness: 1.0,
          height: 1.0,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor.withValues(alpha: 0.1),
                    dividerColor,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '❖',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.accentGoldLight : AppColors.accentGold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor,
                    dividerColor.withValues(alpha: 0.1),
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
