import 'package:flutter/material.dart';

/// Semantic, restrained color palette blending Islamic heritage with modern scientific aesthetics.
abstract class AppColors {
  // Brand Primaries
  static const Color primaryEmerald = Color(0xFF0F5A47);
  static const Color primaryEmeraldLight = Color(0xFF1E8268);
  static const Color primaryEmeraldDark = Color(0xFF0A3C2F);

  // Accents & Secondary
  static const Color accentGold = Color(0xFFC89D47);
  static const Color accentTeal = Color(0xFF1B998B);
  static const Color accentCyan = Color(0xFF0284C7);

  // Evidence Taxonomy Level Colors
  static const Color evidenceStrong = Color(0xFF10B981);       // Verified scientific consensus
  static const Color evidenceEmerging = Color(0xFFF59E0B);     // Peer-reviewed studies in progress
  static const Color evidenceModerate = Color(0xFFF59E0B);     // Alias for emerging/moderate
  static const Color evidencePossible = Color(0xFF0EA5E9);     // Conceptual / linguistic parallel
  static const Color evidenceUnsupported = Color(0xFFEF4444);  // Debunked / popular internet myth

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8FAF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F3);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0C1110);
  static const Color darkSurface = Color(0xFF141C1A);
  static const Color darkSurfaceCard = Color(0xFF141C1A);
  static const Color darkSurfaceSubtle = Color(0xFF1D2825);
  static const Color darkBorder = Color(0xFF263531);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Semantic Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
