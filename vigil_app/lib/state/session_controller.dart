import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import '../config/drowsiness_config.dart';
import '../config/pause_config.dart';
import '../models/driver_status.dart';
import '../models/session_phase.dart';
import '../models/session_state.dart';
import '../services/alert_sound_service.dart';
import '../services/driver_signal.dart';
import '../services/driver_signal_source.dart';
import '../services/focus_score_calculator.dart';
import '../services/ml_kit_driver_signal_source.dart';
import '../services/simulated_driver_signal_source.dart';

/// The single state machine driving the whole app. Every screen reads its
/// data from [state] and calls the transition methods below; nothing else
/// mutates session data.
class SessionController extends ChangeNotifier {
  SessionController({
    DriverSignalSource? signalSource,
    AlertSoundService? soundService,
  })  : _signalSource = signalSource ?? _defaultSignalSource(),
        _soundService = soundService ?? AlertSoundService();

  /// Real camera-backed detection only exists for Android (see
  /// [MlKitDriverSignalSource]); every other platform falls back to the
  /// Phase 1 simulator.
  static DriverSignalSource _defaultSignalSource() {
    if (!kIsWeb && Platform.isAndroid) {
      return MlKitDriverSignalSource();
    }
    return SimulatedDriverSignalSource();
  }

  final DriverSignalSource _signalSource;
  final AlertSoundService _soundService;

  SessionState _state = SessionState.initial();
  SessionState get state => _state;

  StreamSubscription<DriverSignal>? _signalSub;
  Timer? _durationTimer;
  Timer? _pauseTimer;
  DateTime? _pauseDeadline;
  bool _inDrowsyEpisode = false;

  void startSession() {
    _state = SessionState.initial().copyWith(phase: SessionPhase.driving);
    _inDrowsyEpisode = false;
    _beginMonitoring();
    notifyListeners();
  }

  void pauseSession() {
    if (_state.phase != SessionPhase.driving) return;
    _endMonitoring();
    _state = _state.copyWith(
      phase: SessionPhase.paused,
      pauseCount: _state.pauseCount + 1,
      driverStatus: DriverStatus.alert,
      pauseRemaining: PauseConfig.duration,
    );
    notifyListeners();
    _beginPauseCountdown();
  }

  void resumeSession() {
    if (_state.phase != SessionPhase.paused) return;
    _endPauseCountdown();
    _inDrowsyEpisode = false;
    _state = _state.copyWith(
      phase: SessionPhase.driving,
      pauseRemaining: Duration.zero,
    );
    _beginMonitoring();
    notifyListeners();
  }

  void endSession() {
    _endPauseCountdown();
    _endMonitoring();
    _state = _state.copyWith(phase: SessionPhase.summary);
    notifyListeners();
  }

  /// Ticks [state.pauseRemaining] down from [PauseConfig.duration] to zero,
  /// then auto-resumes the drive — the break is fixed-length, not something
  /// the driver can sit in indefinitely.
  void _beginPauseCountdown() {
    _pauseDeadline = DateTime.now().add(PauseConfig.duration);
    _pauseTimer?.cancel();
    _pauseTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final remaining = _pauseDeadline!.difference(DateTime.now());
      if (remaining <= Duration.zero) {
        resumeSession();
        return;
      }
      _state = _state.copyWith(pauseRemaining: remaining);
      notifyListeners();
    });
  }

  void _endPauseCountdown() {
    _pauseTimer?.cancel();
    _pauseTimer = null;
    _pauseDeadline = null;
  }

  void resetToHome() {
    _state = SessionState.initial();
    notifyListeners();
  }

  /// Demo-only: forces a drowsy reading through the simulator so the
  /// drowsy/critical UI can be shown without a real detector. Safely
  /// no-ops once a real [DriverSignalSource] replaces the simulated one.
  void debugTriggerDrowsy(bool isDrowsy) {
    final source = _signalSource;
    if (source is SimulatedDriverSignalSource) {
      source.debugSetForcedDrowsy(isDrowsy);
    }
  }

  void _beginMonitoring() {
    _signalSub?.cancel();
    _signalSub = _signalSource.signals.listen(_onSignal);
    _signalSource.start();

    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _state = _state.copyWith(
        elapsedDriving: _state.elapsedDriving + const Duration(seconds: 1),
      );
      notifyListeners();
    });
  }

  void _endMonitoring() {
    _signalSub?.cancel();
    _signalSub = null;
    _signalSource.stop();
    _durationTimer?.cancel();
    _durationTimer = null;
    _soundService.stopAlarm();
  }

  void _onSignal(DriverSignal signal) {
    if (_state.phase != SessionPhase.driving) return;

    if (signal.status == DriverStatus.drowsy) {
      if (_inDrowsyEpisode) {
        _state = _state.copyWith(lastEar: signal.ear);
        return;
      }

      // Alert -> drowsy transition: count the episode, penalize the focus
      // score once, possibly escalate to "critical", and sound the alarm.
      _inDrowsyEpisode = true;
      final alertCount = _state.drowsinessAlertCount + 1;
      final escalate = alertCount >= DrowsinessConfig.criticalEpisodeCount;

      _state = _state.copyWith(
        driverStatus: escalate ? DriverStatus.critical : DriverStatus.drowsy,
        drowsinessAlertCount: alertCount,
        focusScore: escalate
            ? FocusScoreCalculator.applyCriticalEvent(_state.focusScore)
            : FocusScoreCalculator.applyDrowsyEvent(_state.focusScore),
        lastEar: signal.ear,
      );
      unawaited(_soundService.playAlarm());
      notifyListeners();
    } else {
      if (!_inDrowsyEpisode) {
        _state = _state.copyWith(lastEar: signal.ear);
        return;
      }

      _inDrowsyEpisode = false;
      unawaited(_soundService.stopAlarm());
      _state = _state.copyWith(
        driverStatus: DriverStatus.alert,
        lastEar: signal.ear,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _signalSub?.cancel();
    _durationTimer?.cancel();
    _pauseTimer?.cancel();
    _signalSource.dispose();
    _soundService.dispose();
    super.dispose();
  }
}
