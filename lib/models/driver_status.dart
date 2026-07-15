/// Driver alertness readout shown during a driving session.
///
/// [alert] and [drowsy] mirror the binary signal the detector produces
/// (see `DriverSignal`). [critical] is a pure app-level escalation reached
/// after repeated drowsy episodes in one session — it is never reported
/// directly by the detector.
enum DriverStatus {
  alert,
  drowsy,
  critical,
}

extension DriverStatusLabel on DriverStatus {
  String get label => switch (this) {
        DriverStatus.alert => 'Alert',
        DriverStatus.drowsy => 'Drowsy Detected',
        DriverStatus.critical => 'Take a Break',
      };
}
