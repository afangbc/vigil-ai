import 'package:flutter/material.dart';

import '../models/driver_status.dart';
import 'app_colors.dart';

/// Maps [DriverStatus] to the safe/warning/danger palette. Kept out of
/// `models/` so the model layer stays free of Flutter imports.
Color colorForStatus(DriverStatus status) => switch (status) {
      DriverStatus.alert => AppColors.safe,
      DriverStatus.drowsy => AppColors.warning,
      DriverStatus.critical => AppColors.danger,
    };
