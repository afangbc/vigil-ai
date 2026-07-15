/// mm:ss readout for the live Driving Mode timer.
String formatClock(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Rounded "X minutes" readout used on the Session Summary screen.
String formatMinutes(Duration d) {
  final minutes = (d.inSeconds / 60).round();
  return minutes == 1 ? '1 minute' : '$minutes minutes';
}
