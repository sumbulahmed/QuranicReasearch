import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<String> _notes = [
    'Reflect on the root \'Alaqah\' (عَلَقَة) - linguistic triple meaning: leech-like clot, hanging suspension, blood-clot.',
    'Review Al-Barzakh (الْبَرْزَخ) in Surah Al-Furqan 25:53 alongside pycnocline and halocline oceanographic salinity gradients.',
  ];

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Researcher Profile',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: AppDimensions.paddingScreen,
        children: [
          // User Card (Local Mode)
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryEmerald.withValues(alpha: isDark ? 0.25 : 0.15),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 36,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.evidenceStrong,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Student of Knowledge',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_off_rounded, size: 10, color: AppColors.primaryEmerald),
                                const SizedBox(width: 4),
                                Text(
                                  '100% Offline Local Mode',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primaryEmerald,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Daily Study Streak Tracker
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF261D12), const Color(0xFF1C150D)]
                    : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🔥', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '5-Day Research Streak',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.accentGold : const Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Reflecting consistently on signs in creation and divine revelation.',
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Research Stats Grid
          AppCard(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Knowledge Metrics',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('18', 'Ayahs Read', AppColors.primaryEmerald),
                    _buildStatItem('10', 'Hadiths', AppColors.accentTeal),
                    _buildStatItem('10', 'Topics', AppColors.accentGold),
                    _buildStatItem('${bookmarks.length}', 'Saved', AppColors.accentCyan),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Personal Research Notes Section
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primaryEmerald),
                        const SizedBox(width: 8),
                        Text(
                          'Personal Research Notes',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryEmerald),
                      onPressed: () => _showAddNoteDialog(context),
                      tooltip: 'Add Note',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_notes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No notes yet. Tap + to add research insights.',
                      style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                else
                  ..._notes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final note = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes_rounded, size: 16, color: AppColors.accentTeal),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              note,
                              style: AppTypography.bodySmall.copyWith(
                                color: theme.colorScheme.onSurface,
                                height: 1.4,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16, color: Colors.grey),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _notes.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Navigation Links
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bookmark_outline_rounded, color: AppColors.primaryEmerald),
                  title: const Text('Saved Bookmarks'),
                  subtitle: Text('${bookmarks.length} items saved offline'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => context.push('/library/bookmarks'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.article_outlined, color: AppColors.accentTeal),
                  title: const Text('Scientific Literature Database'),
                  subtitle: const Text('Browse 11 peer-reviewed research papers'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => context.push('/research'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_outlined, color: AppColors.evidenceStrong),
                  title: const Text('Methodology & Evidence Framework'),
                  subtitle: const Text('Review academic principles of Quranic correlation'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showMethodologyDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: Colors.grey),
                  title: const Text('Settings & Typography'),
                  subtitle: const Text('Theme, font size, language & translations'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => context.push('/settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headlineLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(fontSize: 11),
        ),
      ],
    );
  }

  void _showMethodologyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_outlined, color: AppColors.evidenceStrong, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Methodology & Evidence',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          'Our Academic Framework',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This research engine bridges Quranic and Hadith texts with modern empirical science using rigorous hermeneutic boundaries. We prioritize classical exegesis (Tafseer) before exploring scientific correlations, strictly guarding against concordism and pseudoscientific over-interpretation.',
                          style: AppTypography.bodySmall.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Evidence Classification Hierarchy',
                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodologyTier(
                          'Strong Consensus',
                          'Established empirical facts verified by global scientific consensus, matching unambiguous linguistic meanings.',
                          AppColors.evidenceStrong,
                          isDark,
                        ),
                        const SizedBox(height: 10),
                        _buildMethodologyTier(
                          'Emerging Inquiry',
                          'Active peer-reviewed scientific hypotheses with robust empirical basis, subject to ongoing replication.',
                          AppColors.evidenceEmerging,
                          isDark,
                        ),
                        const SizedBox(height: 10),
                        _buildMethodologyTier(
                          'Possible Correlation',
                          'Linguistic or conceptual resonance between scripture and physical models, requiring hermeneutic caution.',
                          AppColors.evidencePossible,
                          isDark,
                        ),
                        const SizedBox(height: 10),
                        _buildMethodologyTier(
                          'Unsupported / Myth',
                          'Popular claims or fabricated correlations lacking either sound philological basis or valid scientific backing.',
                          AppColors.evidenceUnsupported,
                          isDark,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.primaryEmerald, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'All indexed scientific papers undergo bibliographic verification (DOI, peer-reviewed journal indexing, and author verification) before being associated with any theological topic.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMethodologyTier(String title, String desc, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5, right: 10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: AppTypography.bodySmall.copyWith(fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Research Note'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter your research reflection, ayah connection, or note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _notes.add(text);
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}
