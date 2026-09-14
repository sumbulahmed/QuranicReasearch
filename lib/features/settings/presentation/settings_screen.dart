import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/arabic_text.dart';
import '../../../core/models/evidence_level.dart';
import '../../../core/providers/app_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _dailyAyahReminder = true;
  bool _dailyHadithReminder = true;
  bool _dailyScienceReminder = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final rawTranslationPref = ref.watch(translationPreferenceProvider);
    final translationPref = const ['both', 'english', 'urdu'].contains(rawTranslationPref)
        ? rawTranslationPref
        : 'english';
    final rawAppLanguage = ref.watch(appLanguageProvider);
    final appLanguage = (rawAppLanguage == 'ur') ? 'ur' : 'en';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings & Preferences',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: AppDimensions.paddingScreen,
        children: [
          // Theme Settings
          Text(
            'Appearance & Theme',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Mode',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_rounded),
                      label: Text('System'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_rounded),
                      label: Text('Light'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_rounded),
                      label: Text('Dark'),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (set) {
                    ref.read(themeModeProvider.notifier).state = set.first;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Arabic Typography Settings & Live Preview
          Text(
            'Arabic Typography',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Arabic Font Size',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${arabicFontSize.toInt()} pt',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.primaryEmerald,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: arabicFontSize,
                  min: 20,
                  max: 40,
                  divisions: 10,
                  activeColor: AppColors.primaryEmerald,
                  onChanged: (val) {
                    ref.read(arabicFontSizeProvider.notifier).state = val;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Live Preview:',
                  style: AppTypography.labelSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: ArabicText(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nاقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
                    fontSize: arabicFontSize,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Translation & Language Preferences
          Text(
            'Language & Translations',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Translation Display Mode',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select whether to display English, Urdu, or both translations simultaneously.',
                  style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'both', label: Text('Both')),
                    ButtonSegment(value: 'english', label: Text('English')),
                    ButtonSegment(value: 'urdu', label: Text('Urdu')),
                  ],
                  selected: {translationPref},
                  onSelectionChanged: (set) {
                    ref.read(translationPreferenceProvider.notifier).state = set.first;
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('App Interface Language', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                        Text(appLanguage == 'en' ? 'English (Default)' : 'Urdu (اردو)', style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    DropdownButton<String>(
                      value: appLanguage,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ur', child: Text('اردو')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(appLanguageProvider.notifier).state = val;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Notification Toggles (UI only, local)
          Text(
            'Daily Reflections & Notifications',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Daily Ayah Reflection'),
                  subtitle: const Text('Morning notification with an inspiring verse'),
                  value: _dailyAyahReminder,
                  activeTrackColor: AppColors.primaryEmerald,
                  onChanged: (val) => setState(() => _dailyAyahReminder = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Daily Hadith Wisdom'),
                  subtitle: const Text('Afternoon notification from canonical collections'),
                  value: _dailyHadithReminder,
                  activeTrackColor: AppColors.primaryEmerald,
                  onChanged: (val) => setState(() => _dailyHadithReminder = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Scientific Discovery of the Day'),
                  subtitle: const Text('Evening notification on empirical research correlations'),
                  value: _dailyScienceReminder,
                  activeTrackColor: AppColors.primaryEmerald,
                  onChanged: (val) => setState(() => _dailyScienceReminder = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Research Methodology & Taxonomy
          Text(
            'Methodology & Epistemology',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.verified_outlined, color: AppColors.primaryEmerald),
                  title: const Text('Evidence Classification Rubric'),
                  subtitle: const Text('Criteria for Strong, Emerging, and Possible grading'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showEvidenceRubricDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined, color: AppColors.accentTeal),
                  title: const Text('Epistemological Principles'),
                  subtitle: const Text('Differentiating divine revelation from empirical science'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showDisclaimerDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About & Version
          Text(
            'About Bayan',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: AppColors.primaryEmerald, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bayan: Qur\'an & Empirical Science',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Version 1.0.0 (Research Edition - 100% Local)',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'A modern platform bridging divine revelation, classical tafseer, and peer-reviewed empirical science with utmost scholarly rigor, objectivity, and humility.',
                  style: AppTypography.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showEvidenceRubricDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('4-Tier Evidence Taxonomy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRubricItem(EvidenceLevel.strong),
              const SizedBox(height: 10),
              _buildRubricItem(EvidenceLevel.emerging),
              const SizedBox(height: 10),
              _buildRubricItem(EvidenceLevel.possible),
              const SizedBox(height: 10),
              _buildRubricItem(EvidenceLevel.unsupported),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildRubricItem(EvidenceLevel level) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: level.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(level.icon, size: 16, color: level.color),
              const SizedBox(width: 6),
              Text(
                level.label,
                style: AppTypography.labelMedium.copyWith(
                  color: level.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            level.subtitle,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Epistemological Principles'),
        content: const SingleChildScrollView(
          child: Text(
            'The Holy Quran is a book of divine signs (Ayaat) and spiritual guidance, not a technical scientific manual.\n\n'
            'Modern science is an inductive, self-correcting human inquiry whose theories are subject to revision, refinement, and paradigm shifts.\n\n'
            'Therefore, this application strictly maintains that the truth of divine revelation does not depend on transient scientific theories. '
            'Connections shown here represent corroborating observations and reflections rather than dogmatic proofs.\n\n'
            'Any interpretations that stretch Arabic linguistics beyond classical grammatical bounds are rejected.',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}

