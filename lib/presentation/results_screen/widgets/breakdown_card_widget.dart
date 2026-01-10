import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BreakdownCardWidget extends StatelessWidget {
  final int basePoints;
  final double streakMultiplier;
  final double speedBonus;
  final double difficultyMultiplier;
  final bool submittedInTime;
  final AnimationController breakdownController;

  const BreakdownCardWidget({
    Key? key,
    required this.basePoints,
    required this.streakMultiplier,
    required this.speedBonus,
    required this.difficultyMultiplier,
    required this.submittedInTime,
    required this.breakdownController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Breakdown',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildBreakdownItem(
            context,
            label: 'Base Points',
            value: basePoints.toString(),
            progress: 1.0,
            color: theme.colorScheme.primary,
            delay: 0,
          ),
          SizedBox(height: 1.5.h),
          _buildBreakdownItem(
            context,
            label: 'Streak Multiplier',
            value: '${streakMultiplier.toStringAsFixed(1)}x',
            progress: (streakMultiplier - 1.0) / 2.0,
            color: AppTheme.accentLight,
            delay: 200,
          ),
          SizedBox(height: 1.5.h),
          _buildBreakdownItem(
            context,
            label: 'Speed Bonus',
            value: submittedInTime
                ? '${speedBonus.toStringAsFixed(1)}x'
                : 'N/A',
            progress: submittedInTime ? speedBonus / 2.0 : 0,
            color: AppTheme.successLight,
            delay: 400,
          ),
          SizedBox(height: 1.5.h),
          _buildBreakdownItem(
            context,
            label: 'Difficulty Multiplier',
            value: '${difficultyMultiplier.toStringAsFixed(1)}x',
            progress: (difficultyMultiplier - 1.0) / 0.5,
            color: theme.colorScheme.secondary,
            delay: 600,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context, {
    required String label,
    required String value,
    required double progress,
    required Color color,
    required int delay,
  }) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: progress),
      builder: (context, animatedProgress, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: animatedProgress,
                backgroundColor: theme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ],
        );
      },
    );
  }
}
