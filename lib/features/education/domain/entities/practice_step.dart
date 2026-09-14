class PracticeStep {
  final int stepNumber;
  final String title;
  final String instruction;
  final String? arabicPhrase;
  final double waterLevel; // 1.0 (full) down to 0.0 (empty)
  final bool isBreathingPhase;
  final String iconName;

  const PracticeStep({
    required this.stepNumber,
    required this.title,
    required this.instruction,
    this.arabicPhrase,
    required this.waterLevel,
    this.isBreathingPhase = false,
    required this.iconName,
  });
}
