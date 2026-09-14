import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// The 4-tier classification taxonomy for scientific claims linked to Quran and Hadith.
enum EvidenceLevel {
  strong,
  moderate,
  emerging,
  possible,
  unsupported;

  static EvidenceLevel fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'strong':
        return EvidenceLevel.strong;
      case 'moderate':
        return EvidenceLevel.moderate;
      case 'emerging':
        return EvidenceLevel.emerging;
      case 'possible':
        return EvidenceLevel.possible;
      case 'unsupported':
      case 'debunked':
        return EvidenceLevel.unsupported;
      default:
        return EvidenceLevel.possible;
    }
  }

  String get label {
    switch (this) {
      case EvidenceLevel.strong:
        return 'Strong Evidence';
      case EvidenceLevel.moderate:
        return 'Moderate / Contextual Evidence';
      case EvidenceLevel.emerging:
        return 'Emerging Evidence';
      case EvidenceLevel.possible:
        return 'Possible Connection';
      case EvidenceLevel.unsupported:
        return 'Unsupported Claim';
    }
  }

  String get subtitle {
    switch (this) {
      case EvidenceLevel.strong:
        return 'Established scientific consensus with empirical replication';
      case EvidenceLevel.moderate:
        return 'Physiological literature providing contextual framework without proving religious doctrine';
      case EvidenceLevel.emerging:
        return 'Active peer-reviewed studies without full scientific finality';
      case EvidenceLevel.possible:
        return 'Linguistic or conceptual parallel; not empirically proven';
      case EvidenceLevel.unsupported:
        return 'Fringe, popular internet myth, or demonstrably debunked';
    }
  }

  Color get color {
    switch (this) {
      case EvidenceLevel.strong:
        return AppColors.evidenceStrong;
      case EvidenceLevel.moderate:
        return AppColors.evidenceModerate;
      case EvidenceLevel.emerging:
        return AppColors.evidenceEmerging;
      case EvidenceLevel.possible:
        return AppColors.evidencePossible;
      case EvidenceLevel.unsupported:
        return AppColors.evidenceUnsupported;
    }
  }

  IconData get icon {
    switch (this) {
      case EvidenceLevel.strong:
        return Icons.verified_rounded;
      case EvidenceLevel.moderate:
        return Icons.auto_stories_rounded;
      case EvidenceLevel.emerging:
        return Icons.science_rounded;
      case EvidenceLevel.possible:
        return Icons.help_outline_rounded;
      case EvidenceLevel.unsupported:
        return Icons.cancel_outlined;
    }
  }
}
