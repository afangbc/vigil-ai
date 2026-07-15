import 'driver_signal.dart';

/// Anything that can produce a live stream of [DriverSignal]s.
///
/// This is the seam between the UI/state layer and however drowsiness is
/// actually detected. [SessionController] only ever depends on this
/// interface, so swapping [SimulatedDriverSignalSource] for a real
/// implementation backed by a native EventChannel (camera + MediaPipe Face
/// Landmarker running on-device) is a one-file change.
abstract class DriverSignalSource {
  Stream<DriverSignal> get signals;

  void start();
  void stop();
  void dispose();
}
