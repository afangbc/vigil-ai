import 'package:audioplayers/audioplayers.dart';

/// Thin wrapper around a single [AudioPlayer] for the drowsiness alarm.
class AlertSoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAlarm() async {
    await _player.stop();
    await _player.play(AssetSource('audio/alarm.wav'));
  }

  Future<void> stopAlarm() => _player.stop();

  void dispose() {
    _player.dispose();
  }
}
