import 'package:flutter/material.dart';

class SunnahCategory {
  final String id;
  final String name;
  final String arabicName;
  final IconData icon;
  final int count;
  final Color color;

  const SunnahCategory({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.icon,
    required this.count,
    required this.color,
  });
}
