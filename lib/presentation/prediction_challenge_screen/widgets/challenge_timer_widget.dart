import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Challenge timer widget displaying countdown and deadline
/// Shows time remaining with visual urgency indicators
class ChallengeTimerWidget extends StatelessWidget {
  final Duration timeRemaining;
  final DateTime deadline;

  const ChallengeTimerWidget({
    Key? key,
    required this.timeRemaining,
    required this.deadline,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Color _getTimerColor(BuildContext context, Duration duration) {
    final theme = Theme.of(context);
    if (duration.inMinutes < 3) {
      return theme.brightness == Brightness.light
          ? AppTheme.errorLight
          : AppTheme.errorDark;
    } else if (duration.inMinutes < 5) {
      return theme.brightness == Brightness.light
          ? AppTheme.warningLight
          : AppTheme.warningDark;
    }
    return theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerColor = _getTimerColor(context, timeRemaining);
    final isUrgent = timeRemaining.inMinutes < 5;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            timerColor.withValues(alpha: 0.1),
            timerColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: timerColor, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isUrgent ? 'timer' : 'schedule',
                color: timerColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Time Remaining',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: timerColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _formatDuration(timeRemaining),
            style: AppTheme.dataTextStyle(
              isLight: theme.brightness == Brightness.light,
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
            ).copyWith(color: timerColor),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'event',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Deadline: ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isUrgent) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: timerColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: timerColor,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Hurry! Time running out',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: timerColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
