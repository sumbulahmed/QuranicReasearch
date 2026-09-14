import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Serene concentric pulsing rings guiding calm, measured breathing
/// between drinks as practiced in the prophetic Sunnah.
class BreathingAnimationWidget extends StatefulWidget {
  final double size;
  final bool active;

  const BreathingAnimationWidget({
    super.key,
    this.size = 110,
    this.active = true,
  });

  @override
  State<BreathingAnimationWidget> createState() =>
      _BreathingAnimationWidgetState();
}

class _BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.25)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.35, end: 0.8)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 0.35)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant BreathingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pulseColor =
        isDark ? AppColors.accentGoldLight : AppColors.primaryEmerald;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isInhaling = _controller.value < 0.5;
        final phaseLabel = isInhaling ? 'Inhale gently...' : 'Exhale softly...';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: widget.size * 0.95,
                      height: widget.size * 0.95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: pulseColor.withValues(
                              alpha: _opacityAnimation.value * 0.4),
                          width: 1.5,
                        ),
                        color: pulseColor.withValues(
                            alpha: _opacityAnimation.value * 0.08),
                      ),
                    ),
                  ),

                  // Middle ring
                  Transform.scale(
                    scale: _scaleAnimation.value * 0.82,
                    child: Container(
                      width: widget.size * 0.72,
                      height: widget.size * 0.72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: pulseColor.withValues(
                              alpha: _opacityAnimation.value * 0.7),
                          width: 1.8,
                        ),
                        color: pulseColor.withValues(
                            alpha: _opacityAnimation.value * 0.15),
                      ),
                    ),
                  ),

                  // Central core icon
                  Container(
                    width: widget.size * 0.45,
                    height: widget.size * 0.45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.parchmentCard,
                      border: Border.all(
                        color: pulseColor,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: pulseColor.withValues(alpha: 0.25),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.air_rounded,
                      size: widget.size * 0.24,
                      color: pulseColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              phaseLabel,
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryEmerald,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        );
      },
    );
  }
}
