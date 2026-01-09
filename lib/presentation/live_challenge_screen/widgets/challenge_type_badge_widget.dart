import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Challenge Type Badge Widget - Displays challenge type with distinct visual theme
class ChallengeTypeBadgeWidget extends StatelessWidget {
  final String challengeType;

  const ChallengeTypeBadgeWidget({Key? key, required this.challengeType})
    : super(key: key);

  Map<String, dynamic> _getChallengeTheme(ThemeData theme) {
    switch (challengeType) {
      case 'Quiz':
        return {
          'color': Color(0xFF2563EB),
          'icon': 'quiz',
          'label': 'Quiz Challenge',
        };
      case 'Video':
        return {
          'color': Color(0xFF7C3AED),
          'icon': 'videocam',
          'label': 'Video Pitch',
        };
      case 'Prediction':
        return {
          'color': Color(0xFFF59E0B),
          'icon': 'trending_up',
          'label': 'Market Prediction',
        };
      default:
        return {
          'color': theme.colorScheme.primary,
          'icon': 'help',
          'label': 'Challenge',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final challengeTheme = _getChallengeTheme(theme);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: (challengeTheme['color'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: challengeTheme['color'] as Color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: challengeTheme['icon'] as String,
            color: challengeTheme['color'] as Color,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            challengeTheme['label'] as String,
            style: theme.textTheme.labelLarge?.copyWith(
              color: challengeTheme['color'] as Color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
