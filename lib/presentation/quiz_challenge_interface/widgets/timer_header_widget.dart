import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

/// Timer Header Widget
/// Displays countdown timer with question progress indicator
class TimerHeaderWidget extends StatelessWidget {
  final int remainingSeconds;
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onReviewTap;

  const TimerHeaderWidget({
    Key? key,
    required this.remainingSeconds,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onReviewTap,
  }) : super(key: key);

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor(BuildContext context, int seconds) {
    if (seconds <= 60) {
      return AppTheme.errorLight;
    } else if (seconds <= 300) {
      return AppTheme.warningLight;
    }
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerColor = _getTimerColor(context, remainingSeconds);
    final progress = remainingSeconds / 900;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Question Progress
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'quiz',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Question $currentQuestion/$totalQuestions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Review Button
              IconButton(
                onPressed: onReviewTap,
                icon: CustomIconWidget(
                  iconName: 'list',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                tooltip: 'Review all questions',
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Timer Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: timerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: timerColor, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  color: timerColor,
                  size: 28,
                ),
                SizedBox(width: 2.w),
                Text(
                  _formatTime(remainingSeconds),
                  style: AppTheme.dataTextStyle(
                    isLight: theme.brightness == Brightness.light,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: timerColor),
                ),
                SizedBox(width: 2.w),
                Text(
                  'remaining',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: timerColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            ),
          ),
        ],
      ),
    );
  }
}
