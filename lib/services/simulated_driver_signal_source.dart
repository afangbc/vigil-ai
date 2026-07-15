import 'dart:async';

import '../models/driver_status.dart';
import 'driver_signal.dart';
import 'driver_signal_source.dart';

/// Phase 1 stand-in for the real camera/MediaPipe pipeline. Emits an
/// "alert" signal on a steady tick so the UI has something live to render,
/// and lets [debugSetForcedDrowsy] override that for demoing the drowsy/
/// critical states without a real detector. Deleted wholesale once a
/// native-backed [DriverSignalSource] exists.
class SimulatedDriverSignalSource implements DriverSignalSource {
  SimulatedDriverSignalSource({this.tickInterval = const Duration(seconds: 1)});

  final Duration tickInterval;

  final _controller = StreamController<DriverSignal>.broadcast();
  Timer? _timer;
  bool _forcedDrowsy = false;

  @override
  Stream<DriverSignal> get signals => _controller.stream;

  @override
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(tickInterval, (_) => _emit());
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stop();
    _controller.close();
  }

  /// Demo-only hook: force a drowsy reading on/off so the drowsy/critical
  /// UI states can be shown without real detection. No-op once a real
  /// [DriverSignalSource] is wired up in place of this one.
  void debugSetForcedDrowsy(bool isDrowsy) {
    _forcedDrowsy = isDrowsy;
    _emit();
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(
      DriverSignal(
        status: _forcedDrowsy ? DriverStatus.drowsy : DriverStatus.alert,
        ear: _forcedDrowsy ? 0.15 : 0.30,
        timestamp: DateTime.now(),
      ),
    );
  }
}
