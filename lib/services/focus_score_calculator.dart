/// Isolated, pure scoring logic so the formula can be replaced later (e.g.
/// once real EAR/phone-usage signals are available) without touching
/// [SessionController]'s call sites.
class FocusScoreCalculator {
  FocusScoreCalculator._();

  static const int startingScore = 100;
  static const int drowsyPenalty = 10;
  static const int criticalPenalty = 20;

  static int applyDrowsyEvent(int current) =>
      (current - drowsyPenalty).clamp(0, 100).toInt();

  static int applyCriticalEvent(int current) =>
      (current - criticalPenalty).clamp(0, 100).toInt();
}
