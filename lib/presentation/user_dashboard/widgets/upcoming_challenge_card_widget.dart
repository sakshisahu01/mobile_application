import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../../core/app_export.dart';

class UpcomingChallengeCardWidget extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onGetReady;

  const UpcomingChallengeCardWidget({
    Key? key,
    required this.challenge,
    required this.onGetReady,
  }) : super(key: key);

  @override
  State<UpcomingChallengeCardWidget> createState() =>
      _UpcomingChallengeCardWidgetState();
}

class _UpcomingChallengeCardWidgetState
    extends State<UpcomingChallengeCardWidget> {
  late Duration _timeRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateTimer();
    });
  }

  void _updateTimer() {
    if (mounted) {
      _updateTimeRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeRemaining() {
    final scheduledTime = widget.challenge["scheduledTime"] as DateTime;
    setState(() {
      _timeRemaining = scheduledTime.difference(DateTime.now());
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Color _getChallengeTypeColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (widget.challenge["type"]) {
      case 'quiz':
        return theme.colorScheme.primary;
      case 'video':
        return theme.colorScheme.error;
      case 'prediction':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.secondary;
    }
  }

  IconData _getChallengeTypeIcon() {
    switch (widget.challenge["type"]) {
      case 'quiz':
        return Icons.quiz;
      case 'video':
        return Icons.videocam;
      case 'prediction':
        return Icons.trending_up;
      default:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getChallengeTypeColor(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getChallengeTypeIcon(),
                  color: typeColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.challenge["type"].toString().toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: typeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.challenge["title"],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            widget.challenge["description"],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Starts in',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatDuration(_timeRemaining),
                  style: AppTheme.dataTextStyle(
                    isLight: theme.brightness == Brightness.light,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _InfoChip(
                  icon: 'schedule',
                  label: '${widget.challenge["duration"]} min',
                  theme: theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _InfoChip(
                  icon: 'monetization_on',
                  label: '+${widget.challenge["potentialReward"]}',
                  theme: theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _InfoChip(
                  icon: 'signal_cellular_alt',
                  label: widget.challenge["difficulty"],
                  theme: theme,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onGetReady,
              style: ElevatedButton.styleFrom(
                backgroundColor: typeColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              child: Text('Get Ready'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;
  final ThemeData theme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
