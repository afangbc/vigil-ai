/// Ported directly from the Python prototype (`load_model.py`). These are
/// the exact EAR threshold and closed-eye duration used there — any future
/// native (Kotlin/Swift) MediaPipe Face Landmarker port MUST use the same
/// values so on-device behavior matches what was validated in the prototype.
class DrowsinessConfig {
  DrowsinessConfig._();

  /// Below this eye-aspect-ratio, eyes are considered closed.
  static const double earThreshold = 0.21;

  /// Eyes must stay closed continuously for this long to count as a
  /// drowsiness episode.
  static const Duration closedEyeDuration = Duration(seconds: 2);

  /// Number of drowsy episodes in one session before status escalates from
  /// "Drowsy Detected" to "Take a Break". App-level policy, not part of the
  /// ported detection logic.
  static const int criticalEpisodeCount = 3;
}
