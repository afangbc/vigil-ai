/// Fixed duration of a manually-triggered "stop light" pause. The break is
/// non-negotiable — it always runs the full duration and auto-resumes the
/// drive when the countdown ends, rather than staying paused indefinitely.
class PauseConfig {
  PauseConfig._();

  static const Duration duration = Duration(seconds: 45);
}
