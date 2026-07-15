import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';

import '../config/drowsiness_config.dart';
import '../models/driver_status.dart';
import 'driver_signal.dart';
import 'driver_signal_source.dart';

/// Real on-device detector: streams the front camera through ML Kit's Face
/// Mesh (468-point, same landmark topology as the MediaPipe Face Landmarker
/// used in `load_model.py`) and computes eye-aspect-ratio with the exact
/// same landmark indices and [DrowsinessConfig] thresholds as that
/// prototype. Android-only — ML Kit Face Mesh Detection has no iOS build.
///
/// The phone is assumed mounted in fixed portrait orientation (a driving
/// mount), so rotation is derived once from the camera's sensor orientation
/// rather than tracked live.
class MlKitDriverSignalSource implements DriverSignalSource {
  static const _leftEye = [33, 160, 158, 133, 153, 144];
  static const _rightEye = [362, 385, 387, 263, 373, 380];

  final _controller = StreamController<DriverSignal>.broadcast();
  final _meshDetector = FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);

  CameraController? _camera;
  bool _starting = false;
  bool _busy = false;
  DateTime? _closedSince;

  @override
  Stream<DriverSignal> get signals => _controller.stream;

  @override
  void start() {
    if (_starting || _camera != null) return;
    _starting = true;
    unawaited(_startCamera());
  }

  Future<void> _startCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final camera = CameraController(
        front,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await camera.initialize();
      if (_controller.isClosed) {
        await camera.dispose();
        return;
      }
      _camera = camera;
      await camera.startImageStream(_onFrame);
    } catch (_) {
      // Camera unavailable (permission denied, no camera, emulator without
      // one, etc.) — stay silent rather than crash the session. The driver
      // simply gets no readings, same as if monitoring were paused.
    } finally {
      _starting = false;
    }
  }

  void _onFrame(CameraImage image) {
    if (_busy) return;
    _busy = true;
    _analyze(image).whenComplete(() => _busy = false);
  }

  Future<void> _analyze(CameraImage image) async {
    final camera = _camera;
    if (camera == null || image.planes.length != 1) return;

    final plane = image.planes.first;
    final inputImage = InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotationValue.fromRawValue(
              camera.description.sensorOrientation,
            ) ??
            InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );

    final meshes = await _meshDetector.processImage(inputImage);
    if (_controller.isClosed || meshes.isEmpty) return;

    final byIndex = <int, FaceMeshPoint>{
      for (final p in meshes.first.points) p.index: p,
    };

    final ear = _averageEar(byIndex);
    if (ear == null) return;

    _emit(ear);
  }

  double? _averageEar(Map<int, FaceMeshPoint> points) {
    final left = _ear(points, _leftEye);
    final right = _ear(points, _rightEye);
    if (left == null || right == null) return null;
    return (left + right) / 2;
  }

  double? _ear(Map<int, FaceMeshPoint> points, List<int> eyeIndices) {
    final p = eyeIndices.map((i) => points[i]).toList();
    if (p.any((point) => point == null)) return null;

    final vertical1 = _dist(p[1]!, p[5]!);
    final vertical2 = _dist(p[2]!, p[4]!);
    final horizontal = _dist(p[0]!, p[3]!);
    if (horizontal == 0) return null;

    return (vertical1 + vertical2) / (2 * horizontal);
  }

  double _dist(FaceMeshPoint a, FaceMeshPoint b) =>
      math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));

  void _emit(double ear) {
    final now = DateTime.now();
    bool drowsy;

    if (ear < DrowsinessConfig.earThreshold) {
      _closedSince ??= now;
      drowsy = now.difference(_closedSince!) >= DrowsinessConfig.closedEyeDuration;
    } else {
      _closedSince = null;
      drowsy = false;
    }

    _controller.add(DriverSignal(
      status: drowsy ? DriverStatus.drowsy : DriverStatus.alert,
      ear: ear,
      timestamp: now,
    ));
  }

  @override
  void stop() {
    unawaited(_camera?.stopImageStream());
  }

  @override
  void dispose() {
    stop();
    unawaited(_camera?.dispose());
    _camera = null;
    unawaited(_meshDetector.close());
    unawaited(_controller.close());
  }
}
