import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Confidence level selector widget
/// Allows users to indicate prediction certainty affecting potential rewards
class ConfidenceSelectorWidget extends StatelessWidget {
  final int selectedConfidence;
  final Function(int) onConfidenceChanged;

  const ConfidenceSelectorWidget({
    Key? key,
    required this.selectedConfidence,
    required this.onConfidenceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confidenceLevels = [
      {
        'level': 1,
        'label': 'Low',
        'multiplier': '1.0x',
        'icon': 'sentiment_neutral',
      },
      {
        'level': 2,
        'label': 'Medium',
        'multiplier': '1.5x',
        'icon': 'sentiment_satisfied',
      },
      {
        'level': 3,
        'label': 'High',
        'multiplier': '2.0x',
        'icon': 'sentiment_very_satisfied',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Confidence Level',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Higher confidence = Higher rewards if correct',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: confidenceLevels.map((level) {
              final isSelected = selectedConfidence == (level['level'] as int);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: InkWell(
                    onTap: () => onConfidenceChanged(level['level'] as int),
                    borderRadius: BorderRadius.circular(2.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: level['icon'] as String,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            level['label'] as String,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            level['multiplier'] as String,
                            style:
                                AppTheme.dataTextStyle(
                                  isLight: theme.brightness == Brightness.light,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
