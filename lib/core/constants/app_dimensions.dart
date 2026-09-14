import 'package:flutter/material.dart';

abstract class AppDimensions {
  // Spacing
  static const double space2xs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;

  // Border Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Padding Insets
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets paddingCard = EdgeInsets.all(16.0);
  static const EdgeInsets paddingCardSm = EdgeInsets.all(12.0);

  // Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
}
