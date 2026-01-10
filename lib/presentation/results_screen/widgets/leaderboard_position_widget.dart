import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class LeaderboardPositionWidget extends StatefulWidget {
  final int previousRank;
  final int currentRank;
  final int currentStreak;

  const LeaderboardPositionWidget({
    Key? key,
    required this.previousRank,
    required this.currentRank,
    required this.currentStreak,
  }) : super(key: key);

  @override
  State<LeaderboardPositionWidget> createState() =>
      _LeaderboardPositionWidgetState();
}

class _LeaderboardPositionWidgetState extends State<LeaderboardPositionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rankController;
  late Animation<int> _rankAnimation;

  @override
  void initState() {
    super.initState();
    _rankController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rankAnimation =
        IntTween(begin: widget.previousRank, end: widget.currentRank).animate(
          CurvedAnimation(parent: _rankController, curve: Curves.easeOutCubic),
        );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _rankController.forward();
    });
  }

  @override
  void dispose() {
    _rankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rankImproved = widget.currentRank < widget.previousRank;
    final rankChange = (widget.previousRank - widget.currentRank).abs();

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leaderboard Position',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  AnimatedBuilder(
                    animation: _rankAnimation,
                    builder: (context, child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '#${_rankAnimation.value}',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          if (rankImproved)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'arrow_upward',
                                    color: AppTheme.successLight,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '$rankChange',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.successLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.accentLight,
                      AppTheme.accentLight.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${widget.currentStreak}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Day Streak',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
