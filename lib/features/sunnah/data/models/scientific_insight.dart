class ScientificInsight {
  final String title;
  final String summary;
  final String mechanism;
  final String evidenceLevel;
  final String limitations;
  final String? iconName;

  const ScientificInsight({
    required this.title,
    required this.summary,
    required this.mechanism,
    required this.evidenceLevel,
    required this.limitations,
    this.iconName,
  });
}
