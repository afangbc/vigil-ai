import 'driver_status.dart';
import 'session_phase.dart';

/// Immutable snapshot of the entire driving session, rendered directly by
/// the UI. Nothing in here is camera- or model-specific — it stays valid
/// whether it's fed by the Phase 1 simulator or a real detector later.
class SessionState {
  final SessionPhase phase;
  final DriverStatus driverStatus;
  final Duration elapsedDriving;
  final int focusScore;
  final int drowsinessAlertCount;
  final int pauseCount;

  /// Time left in the current Safe Pause countdown. Zero outside of
  /// [SessionPhase.paused].
  final Duration pauseRemaining;

  /// Last raw eye-aspect-ratio reading, kept for debugging only. Never
  /// rendered — the interface must stay free of technical detail.
  final double? lastEar;

  const SessionState({
    required this.phase,
    required this.driverStatus,
    required this.elapsedDriving,
    required this.focusScore,
    required this.drowsinessAlertCount,
    required this.pauseCount,
    this.pauseRemaining = Duration.zero,
    this.lastEar,
  });

  factory SessionState.initial() => const SessionState(
        phase: SessionPhase.idle,
        driverStatus: DriverStatus.alert,
        elapsedDriving: Duration.zero,
        focusScore: 100,
        drowsinessAlertCount: 0,
        pauseCount: 0,
        pauseRemaining: Duration.zero,
        lastEar: null,
      );

  SessionState copyWith({
    SessionPhase? phase,
    DriverStatus? driverStatus,
    Duration? elapsedDriving,
    int? focusScore,
    int? drowsinessAlertCount,
    int? pauseCount,
    Duration? pauseRemaining,
    double? lastEar,
  }) {
    return SessionState(
      phase: phase ?? this.phase,
      driverStatus: driverStatus ?? this.driverStatus,
      elapsedDriving: elapsedDriving ?? this.elapsedDriving,
      focusScore: focusScore ?? this.focusScore,
      drowsinessAlertCount: drowsinessAlertCount ?? this.drowsinessAlertCount,
      pauseCount: pauseCount ?? this.pauseCount,
      pauseRemaining: pauseRemaining ?? this.pauseRemaining,
      lastEar: lastEar ?? this.lastEar,
    );
  }
}
