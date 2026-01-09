import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Prediction Content Widget - Market/pop-culture prediction interface
class PredictionContentWidget extends StatelessWidget {
  final double predictionValue;
  final Function(double) onPredictionChanged;

  const PredictionContentWidget({
    Key? key,
    required this.predictionValue,
    required this.onPredictionChanged,
  }) : super(key: key);

  // Mock prediction scenarios
  static final List<Map<String, dynamic>> _predictionScenarios = [
    {
      "id": 1,
      "category": "Cryptocurrency",
      "title": "Bitcoin Price Prediction",
      "description": "Predict Bitcoin's price movement in the next 24 hours",
      "currentValue": "\$42,150",
      "icon": "currency_bitcoin",
      "color": Color(0xFFF59E0B),
      "minLabel": "Down 10%",
      "maxLabel": "Up 10%",
    },
    {
      "id": 2,
      "category": "Stock Market",
      "title": "Tech Stock Index",
      "description": "Will NASDAQ close higher or lower tomorrow?",
      "currentValue": "15,234 pts",
      "icon": "trending_up",
      "color": Color(0xFF2563EB),
      "minLabel": "Lower",
      "maxLabel": "Higher",
    },
    {
      "id": 3,
      "category": "Pop Culture",
      "title": "Viral Content Prediction",
      "description": "Which content type will trend most this week?",
      "currentValue": "Short Videos",
      "icon": "movie",
      "color": Color(0xFF7C3AED),
      "minLabel": "Photos",
      "maxLabel": "Videos",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scenario = _predictionScenarios[0]; // Using first scenario for demo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scenario card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (scenario['color'] as Color).withValues(alpha: 0.2),
                (scenario['color'] as Color).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scenario['color'] as Color, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: scenario['color'] as Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: scenario['icon'] as String,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario['category'] as String,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scenario['color'] as Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          scenario['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              Text(
                scenario['description'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 3.h),

              // Current value display
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Value:',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      scenario['currentValue'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scenario['color'] as Color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Prediction slider section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make Your Prediction',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'Slide to predict the outcome. More accurate predictions earn higher rewards!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 4.h),

              // Prediction value display
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (scenario['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${predictionValue.toStringAsFixed(0)}%',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: scenario['color'] as Color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Slider
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: scenario['color'] as Color,
                  thumbColor: scenario['color'] as Color,
                  overlayColor: (scenario['color'] as Color).withValues(
                    alpha: 0.2,
                  ),
                  inactiveTrackColor: theme.colorScheme.outline,
                  trackHeight: 1.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.w),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 5.w),
                ),
                child: Slider(
                  value: predictionValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: onPredictionChanged,
                ),
              ),

              // Slider labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    scenario['minLabel'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    scenario['maxLabel'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Prediction tips
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2563EB), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWidget(
                iconName: 'lightbulb_outline',
                color: Color(0xFF2563EB),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prediction Tips',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '• Consider recent market trends\n• Factor in current events\n• Trust your analysis',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Color(0xFF2563EB),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

