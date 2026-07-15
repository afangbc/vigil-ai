import '../models/driver_status.dart';

/// A single reading from whatever is watching the driver — the Phase 1
/// simulator today, a native EventChannel later. [status] is binary
/// (alert/drowsy) because that mirrors the Python prototype's `drowsy`
/// bool; [DriverStatus.critical] is derived app-side, not carried here.
class DriverSignal {
  final DriverStatus status;
  final double? ear;
  final DateTime timestamp;

  const DriverSignal({
    required this.status,
    required this.timestamp,
    this.ear,
  });
}
