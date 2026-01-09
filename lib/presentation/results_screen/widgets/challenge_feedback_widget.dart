import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ChallengeFeedbackWidget extends StatelessWidget {
  final String challengeType;
  final int correctAnswers;
  final int totalQuestions;
  final int accuracy;
  final List<Map<String, dynamic>> quizFeedback;

  const ChallengeFeedbackWidget({
    Key? key,
    required this.challengeType,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.accuracy,
    required this.quizFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 90.w,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Challenge Feedback',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: _getAccuracyColor(accuracy).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$accuracy% Accuracy',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _getAccuracyColor(accuracy),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                '$correctAnswers / $totalQuestions Correct',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (challengeType == 'quiz') ..._buildQuizFeedback(context),
        ],
      ),
    );
  }

  List<Widget> _buildQuizFeedback(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> feedbackWidgets = [];

    for (int i = 0; i < quizFeedback.length && i < 3; i++) {
      final feedback = quizFeedback[i];
      final isCorrect = feedback["isCorrect"] as bool;

      feedbackWidgets.add(
        Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isCorrect
                ? AppTheme.successLight.withValues(alpha: 0.05)
                : AppTheme.errorLight.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCorrect
                  ? AppTheme.successLight.withValues(alpha: 0.3)
                  : AppTheme.errorLight.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: isCorrect ? 'check_circle' : 'cancel',
                    color: isCorrect
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      feedback["question"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (!isCorrect) ...[
                SizedBox(height: 1.h),
                Text(
                  'Your answer: ${feedback["userAnswer"]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
                ),
                Text(
                  'Correct answer: ${feedback["correctAnswer"]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              SizedBox(height: 1.h),
              Text(
                feedback["explanation"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    if (quizFeedback.length > 3) {
      feedbackWidgets.add(
        Center(
          child: TextButton(
            onPressed: () {
              // Show all feedback in a modal
            },
            child: Text(
              'View All ${quizFeedback.length} Questions',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return feedbackWidgets;
  }

  Color _getAccuracyColor(int accuracy) {
    if (accuracy >= 80) return AppTheme.successLight;
    if (accuracy >= 60) return AppTheme.accentLight;
    return AppTheme.errorLight;
  }
}
