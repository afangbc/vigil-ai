/// The top-level state machine for a Vigil driving session.
///
/// The app has no free navigation — [SessionPhase] is the only thing that
/// decides which screen is on screen, so there's exactly one path through
/// the app and no way to land on a stale/inconsistent screen.
enum SessionPhase {
  idle,
  driving,
  paused,
  summary,
}
