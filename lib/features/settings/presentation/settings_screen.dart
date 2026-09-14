import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/models/evidence_level.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _arabicFontSize = 24.0;
  bool _showDiacritics = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          // Arabic Reading Settings
          Text(
            'Quranic Typography',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Arabic Font Size'),
                    Text('${_arabicFontSize.toInt()} pt',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _arabicFontSize,
                  min: 18,
                  max: 36,
                  divisions: 9,
                  activeColor: AppColors.primaryEmerald,
                  onChanged: (val) => setState(() => _arabicFontSize = val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show Full Diacritics (Tashkeel)'),
                  value: _showDiacritics,
                  activeTrackColor: AppColors.primaryEmerald,
                  onChanged: (val) => setState(() => _showDiacritics = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Research & Scientific Methodology
          Text(
            'Research Methodology & Taxonomy',
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
                  subtitle: const Text('How Strong, Emerging, and Possible are graded'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showEvidenceRubricDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined, color: AppColors.accentTeal),
                  title: const Text('Epistemological Disclaimer'),
                  subtitle: const Text('The distinction between divine text and empirical science'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showDisclaimerDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About & Version
          Text(
            'About',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quran & Evidence-Based Science App',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0 (Research Edition)',
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A platform designed to foster critical thinking, deep Quranic contemplation, and scientific literacy among youth without apologetic pseudoscience.',
                  style: AppTypography.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
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
        title: const Text('Epistemological Disclaimer'),
        content: const SingleChildScrollView(
          child: Text(
            'The Holy Quran is a book of divine signs (Ayaat) and spiritual guidance, not a technical scientific textbook.\n\n'
            'Modern science is an inductive, self-correcting human inquiry whose theories are subject to revision and paradigm shifts. '
            'Therefore, this application strictly maintains that the truth of divine revelation does not depend on transient scientific theories. '
            'Connections shown here represent corroborating observations and reflections rather than dogmatic proofs.',
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
