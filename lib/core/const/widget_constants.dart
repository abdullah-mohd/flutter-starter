import 'package:flutter/material.dart';
import 'package:app/core/const/constants.dart';

Color getActivityColor(String activityType) {
  return activityType.contains('run') || activityType.contains('walk')
      ? runRed
      : activityType.contains('bike') ||
              activityType.contains('cycling') ||
              activityType.contains('biking')
          ? bikeGreen
          : activityType.contains('swim')
              ? swimBlue
              : Colors.deepPurple;
}
