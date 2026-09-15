import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/evidence_badge.dart';
import '../../../../core/widgets/research_citation_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/sunnah_providers.dart';

class SunnahVideoScreen extends ConsumerStatefulWidget {
  final String sunnahId;

  const SunnahVideoScreen({
    super.key,
    required this.sunnahId,
  });

  @override
  ConsumerState<SunnahVideoScreen> createState() => _SunnahVideoScreenState();
}

class _SunnahVideoScreenState extends ConsumerState<SunnahVideoScreen> {
  bool _isPlaying = true;
  double _progress = 0.35;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sunnahAsync = ref.watch(sunnahDetailProvider(widget.sunnahId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scientific Animation',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
      ),
      body: AppBackground(
        child: sunnahAsync.when(
          data: (practice) {
            if (practice == null) {
              return const Center(child: Text('Sunnah not found'));
            }

            return ListView(
              padding: AppDimensions.paddingScreen,
              children: [
                // 1. Video Player Container (Google Flow animation preview player)
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.primaryMaroon.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Video Animation Canvas Simulation
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentGoldLight.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: AppColors.accentGoldLight.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                _isPlaying ? Icons.motion_photos_on_rounded : Icons.play_arrow_rounded,
                                size: 40,
                                color: AppColors.accentGoldLight,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Google Flow Educational Animation',
                              style: AppTypography.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Swallowing Biomechanics & Respiratory Coordination',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Player Controls Overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(AppDimensions.radiusMd),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                  trackHeight: 2.5,
                                  activeTrackColor: AppColors.accentGoldLight,
                                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                                  thumbColor: AppColors.accentGoldLight,
                                ),
                                child: Slider(
                                  value: _progress,
                                  onChanged: (val) => setState(() => _progress = val),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    onPressed: () => setState(() => _isPlaying = !_isPlaying),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '01:12 / 03:20',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() => _isMuted = !_isMuted),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Video Title & Meta
                AppCard(
                  padding: AppDimensions.paddingCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              practice.category,
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                          EvidenceBadge(level: practice.evidenceLevel, compact: true),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Scientific Animation: ${practice.title}',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextHeading : AppColors.lightTextHeading,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        practice.scientificPerspective ??
                            'Visualizing human physiology, upright seated deglutition mechanics, and respiratory intervals.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Research Literature Referenced in Video
                if (practice.researchStudies.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Referenced Research',
                    subtitle: 'Studies Visualized in This Video',
                  ),
                  const SizedBox(height: 10),
                  ...practice.researchStudies.map(
                    (paper) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ResearchCitationCard(paper: paper),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Scientific Disclaimer
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '“Scientific research can help us understand human physiology, but it should not be used to force scientific explanations onto religious texts. The Sunnah is followed because it is the Sunnah. Scientific evidence presented here describes research findings and possible physiological connections.”',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontStyle: FontStyle.italic,
                            height: 1.45,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
