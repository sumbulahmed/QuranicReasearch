import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'app_card.dart';

class ResearchCitationCard extends StatelessWidget {
  final String title;
  final List<String> authors;
  final String journal;
  final int publicationYear;
  final String? doi;
  final String? url;
  final String? abstractSummary;
  final bool isPeerReviewed;

  const ResearchCitationCard({
    super.key,
    required this.title,
    required this.authors,
    required this.journal,
    required this.publicationYear,
    this.doi,
    this.url,
    this.abstractSummary,
    this.isPeerReviewed = true,
  });

  Future<void> _launchUrl(String targetUrl) async {
    final uri = Uri.tryParse(targetUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final targetUrl = url ?? (doi != null ? 'https://doi.org/$doi' : null);

    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 20,
                  color: AppColors.accentTeal,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      authors.join(', '),
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  '$journal ($publicationYear)',
                  style: AppTypography.labelSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (isPeerReviewed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 12, color: AppColors.evidenceStrong),
                      const SizedBox(width: 4),
                      Text(
                        'Peer-Reviewed',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.evidenceStrong,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (abstractSummary != null && abstractSummary!.isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              abstractSummary!,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ],
          if (targetUrl != null) ...[
            const SizedBox(height: 12.0),
            InkWell(
              onTap: () => _launchUrl(targetUrl),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 14,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      doi != null ? 'DOI: $doi' : 'View Source Publication',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
