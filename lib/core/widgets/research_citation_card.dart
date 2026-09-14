import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'app_card.dart';

/// Vintage academic journal citation card presenting peer-reviewed literature.
class ResearchCitationCard extends StatelessWidget {
  final String title;
  final List<String> authors;
  final String journal;
  final int publicationYear;
  final String? doi;
  final String? url;
  final String? abstractSummary;
  final bool isPeerReviewed;

  ResearchCitationCard({
    super.key,
    dynamic paper,
    String? title,
    List<String>? authors,
    String? journal,
    int? publicationYear,
    String? doi,
    String? url,
    String? abstractSummary,
    bool? isPeerReviewed,
  })  : title = paper != null ? paper.title as String : (title ?? ''),
        authors = paper != null ? (paper.authors as List<dynamic>).cast<String>() : (authors ?? const []),
        journal = paper != null ? paper.journal as String : (journal ?? ''),
        publicationYear = paper != null ? paper.publicationYear as int : (publicationYear ?? 2020),
        doi = paper != null ? paper.doi as String? : doi,
        url = paper != null ? paper.sourceUrl as String? : url,
        abstractSummary = paper != null ? paper.abstractSummary as String? : abstractSummary,
        isPeerReviewed = paper != null ? (paper.isPeerReviewed as bool? ?? true) : (isPeerReviewed ?? true);

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
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                        .withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 18,
                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
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
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      authors.join(', '),
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontStyle: FontStyle.italic,
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
            runSpacing: 5.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '$journal • $publicationYear',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              if (isPeerReviewed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(
                      color: AppColors.evidenceStrong.withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_outlined, size: 12, color: AppColors.evidenceStrong),
                      const SizedBox(width: 4),
                      Text(
                        'Peer-Reviewed Academic Study',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.evidenceStrong,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'DEMO RECORD',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          if (abstractSummary != null && abstractSummary!.isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              abstractSummary!,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                height: 1.55,
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
                    Icon(
                      Icons.menu_book_outlined,
                      size: 14,
                      color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      doi != null ? 'DOI: $doi' : 'View Source Publication',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
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
