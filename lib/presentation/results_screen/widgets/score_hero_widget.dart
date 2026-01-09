import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ScoreHeroWidget extends StatelessWidget {
  final int totalScore;
  final int coinsEarned;
  final int xpEarned;
  final AnimationController scoreController;

  const ScoreHeroWidget({
    Key? key,
    required this.totalScore,
    required this.coinsEarned,
    required this.xpEarned,
    required this.scoreController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: scoreController, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: scoreAnimation,
      builder: (context, child) {
        return Container(
          width: 90.w,
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Challenge Complete!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${(totalScore * scoreAnimation.value).toInt()}',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 28.sp,
                ),
              ),
              Text(
                'Total Score',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRewardCounter(
                    context,
                    icon: 'monetization_on',
                    value: (coinsEarned * scoreAnimation.value).toInt(),
                    label: 'Coins',
                    color: AppTheme.accentLight,
                  ),
                  Container(
                    width: 1,
                    height: 6.h,
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                  ),
                  _buildRewardCounter(
                    context,
                    icon: 'stars',
                    value: (xpEarned * scoreAnimation.value).toInt(),
                    label: 'XP',
                    color: AppTheme.successLight,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardCounter(
    BuildContext context, {
    required String icon,
    required int value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CustomIconWidget(iconName: icon, color: color, size: 32),
        SizedBox(height: 1.h),
        Text(
          '+$value',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
