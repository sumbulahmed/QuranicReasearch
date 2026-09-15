class SunnahStep {
  final int stepNumber;
  final String title;
  final String description;
  final String? arabicPhrase;
  final String? iconName;
  final double? progressValue;

  const SunnahStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.arabicPhrase,
    this.iconName,
    this.progressValue,
  });
}
