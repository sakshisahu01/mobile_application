import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Market prediction widget for crypto/stock price predictions
/// Features interactive slider with real-time value updates
class MarketPredictionWidget extends StatefulWidget {
  final Map<String, dynamic> challengeData;
  final Function(double) onPredictionChanged;
  final double currentPrediction;

  const MarketPredictionWidget({
    Key? key,
    required this.challengeData,
    required this.onPredictionChanged,
    required this.currentPrediction,
  }) : super(key: key);

  @override
  State<MarketPredictionWidget> createState() => _MarketPredictionWidgetState();
}

class _MarketPredictionWidgetState extends State<MarketPredictionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minValue = (widget.challengeData['minValue'] as num).toDouble();
    final maxValue = (widget.challengeData['maxValue'] as num).toDouble();
    final currentValue = (widget.challengeData['currentValue'] as num)
        .toDouble();
    final assetName = widget.challengeData['assetName'] as String;
    final assetSymbol = widget.challengeData['assetSymbol'] as String;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assetName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      assetSymbol,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Current Price',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '\$${currentValue.toStringAsFixed(2)}',
                      style: AppTheme.dataTextStyle(
                        isLight: theme.brightness == Brightness.light,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              children: [
                Text(
                  'Your Prediction',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '\$${widget.currentPrediction.toStringAsFixed(2)}',
                  style: AppTheme.dataTextStyle(
                    isLight: theme.brightness == Brightness.light,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Min',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '\$${minValue.toStringAsFixed(2)}',
                    style: AppTheme.dataTextStyle(
                      isLight: theme.brightness == Brightness.light,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Max',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '\$${maxValue.toStringAsFixed(2)}',
                    style: AppTheme.dataTextStyle(
                      isLight: theme.brightness == Brightness.light,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 1.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.w),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 5.w),
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: theme.colorScheme.outline,
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: widget.currentPrediction,
              min: minValue,
              max: maxValue,
              divisions: ((maxValue - minValue) * 100).toInt(),
              onChanged: widget.onPredictionChanged,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(color: theme.colorScheme.outline, width: 1),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Slide to predict the price at challenge end time',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
