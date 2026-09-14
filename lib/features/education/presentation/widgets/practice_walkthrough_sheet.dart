import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../../domain/entities/practice_step.dart';
import 'animated_water_glass.dart';
import 'breathing_animation_widget.dart';

/// Full interactive guided walkthrough modal providing step-by-step
/// instruction with auto-play, animated fluid physics, and breathing cycles.
class PracticeWalkthroughSheet extends StatefulWidget {
  final List<PracticeStep> steps;
  final int initialIndex;

  const PracticeWalkthroughSheet({
    super.key,
    required this.steps,
    this.initialIndex = 0,
  });

  static Future<void> show(BuildContext context, List<PracticeStep> steps) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PracticeWalkthroughSheet(steps: steps),
    );
  }

  @override
  State<PracticeWalkthroughSheet> createState() =>
      _PracticeWalkthroughSheetState();
}

class _PracticeWalkthroughSheetState extends State<PracticeWalkthroughSheet> {
  late int _currentIndex;
  bool _isPlaying = false;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _toggleAutoPlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startAutoPlayTimer();
      } else {
        _autoPlayTimer?.cancel();
      }
    });
  }

  void _startAutoPlayTimer() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex < widget.steps.length - 1) {
        setState(() => _currentIndex++);
      } else {
        setState(() => _isPlaying = false);
        timer.cancel();
      }
    });
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      if (_isPlaying) _startAutoPlayTimer();
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.steps.length - 1) {
      setState(() => _currentIndex++);
      if (_isPlaying) _startAutoPlayTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final step = widget.steps[_currentIndex];
    final totalSteps = widget.steps.length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.parchmentBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.accentGold.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRACTICE GUIDE',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.primaryMaroon,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        fontSize: 10.5,
                      ),
                    ),
                    Text(
                      'Step ${_currentIndex + 1} of $totalSteps',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextHeading
                            : AppColors.lightTextHeading,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _toggleAutoPlay,
                      icon: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 20,
                      ),
                      tooltip: _isPlaying ? 'Pause Auto-Play' : 'Auto-Play Walkthrough',
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Close Guide',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Linear Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / totalSteps,
                minHeight: 3.5,
                backgroundColor: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.parchmentBorder,
                valueColor: AlwaysStoppedAnimation(
                  isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                ),
              ),
            ),
          ),

          // Central Animated Interactive Stage
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visual Stage Area (Glass / Breathing Ring / Seated Illustration)
                  Container(
                    height: 220,
                    alignment: Alignment.center,
                    child: step.isBreathingPhase
                        ? const BreathingAnimationWidget(size: 140, active: true)
                        : AnimatedWaterGlass(
                            targetLevel: step.waterLevel,
                            statusLabel: step.waterLevel > 0.6
                                ? 'Full Vessel • Sip 1'
                                : (step.waterLevel > 0.2
                                    ? 'Sip 2 Taken'
                                    : (step.waterLevel > 0.01
                                        ? 'Sip 3 Complete'
                                        : 'Vessel Empty')),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Arabic Calligraphy if applicable
                  if (step.arabicPhrase != null) ...[
                    ArabicText(
                      step.arabicPhrase!,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Step Title
                  Text(
                    step.title,
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextHeading
                          : AppColors.primaryMaroon,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Step Instruction Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      step.instruction,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextPrimary,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentCard,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  OutlinedButton.icon(
                    onPressed: _goToPrevious,
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextHeading,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.parchmentBorder,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  )
                else
                  const SizedBox(width: 80),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _goToNext,
                  icon: Icon(
                    _currentIndex == totalSteps - 1
                        ? Icons.check_circle_outline_rounded
                        : Icons.arrow_forward_rounded,
                    size: 16,
                  ),
                  label: Text(_currentIndex == totalSteps - 1
                      ? 'Complete'
                      : 'Next Step'),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.accentGoldLight
                        : AppColors.primaryMaroon,
                    foregroundColor:
                        isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
