import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Challenge Timer Widget - Displays countdown timer with color-coded urgency
class ChallengeTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final AnimationController animationController;

  const ChallengeTimerWidget({
    Key? key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.animationController,
  }) : super(key: key);

  Color _getTimerColor(ThemeData theme) {
    final percentage = remainingSeconds / totalSeconds;

    if (percentage > 0.5) {
      return Color(0xFF059669); // Green - plenty of time
    } else if (percentage > 0.2) {
      return Color(0xFFF59E0B); // Yellow - getting urgent
    } else {
      return Color(0xFFDC2626); // Red - critical time
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerColor = _getTimerColor(theme);
    final progress = remainingSeconds / totalSeconds;

    return Column(
      children: [
        // Circular progress indicator with timer
        CircularPercentIndicator(
          radius: 20.w,
          lineWidth: 2.w,
          percent: progress,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(remainingSeconds),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: timerColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'remaining',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          progressColor: timerColor,
          backgroundColor: theme.colorScheme.surface,
          circularStrokeCap: CircularStrokeCap.round,
          animation: false,
        ),

        SizedBox(height: 2.h),

        // Time status text
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: timerColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: progress > 0.2 ? 'access_time' : 'warning',
                color: timerColor,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                progress > 0.5
                    ? 'You have plenty of time'
                    : progress > 0.2
                    ? 'Time is running out'
                    : 'Hurry! Submit now',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: timerColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
