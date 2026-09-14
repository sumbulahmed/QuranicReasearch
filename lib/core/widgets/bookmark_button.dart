import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Refined classic bookmark toggle button.
class BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onPressed;
  final double size;

  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onPressed,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon;
    final inactiveColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        size: size,
        color: isBookmarked ? activeColor : inactiveColor,
      ),
      tooltip: isBookmarked ? 'Remove Bookmark' : 'Save to Bookmarks',
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
    );
  }
}
