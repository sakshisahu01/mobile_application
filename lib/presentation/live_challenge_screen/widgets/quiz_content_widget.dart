import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Quiz Content Widget - Displays quiz questions with multiple choice options
class QuizContentWidget extends StatelessWidget {
  final int currentQuestionIndex;
  final Map<int, String> selectedAnswers;
  final Function(int, String) onAnswerSelected;
  final VoidCallback onNextQuestion;
  final VoidCallback onPreviousQuestion;
  final VoidCallback? onOpenCamera; // open video recorder
  final VoidCallback? onOpenMic; // open audio recorder
  final String? recordedAudioPath;
  final String? recordedVideoPath;

  const QuizContentWidget({
    Key? key,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.onNextQuestion,
    required this.onPreviousQuestion,
    this.onOpenCamera,
    this.onOpenMic,
    this.recordedAudioPath,
    this.recordedVideoPath,
  }) : super(key: key);

  // Mock quiz questions
  static final List<Map<String, dynamic>> _quizQuestions = [
    {
      "id": 1,
      "question":
          "What is the primary benefit of micro-learning in skill development?",
      "options": [
        "Longer study sessions",
        "Better retention through spaced repetition",
        "More complex topics",
        "Less engagement",
      ],
      "type": "multiple_choice",
    },
    {
      "id": 2,
      "question":
          "Time-sensitive challenges create genuine FOMO by limiting availability.",
      "options": ["True", "False"],
      "type": "true_false",
    },
    {
      "id": 3,
      "question":
          "Which gamification element is most effective for consistent user engagement?",
      "options": [
        "One-time rewards",
        "Streak multipliers",
        "Random prizes",
        "Static leaderboards",
      ],
      "type": "multiple_choice",
    },
    {
      "id": 4,
      "question":
          "What percentage of users prefer mobile-first learning experiences?",
      "options": ["45%", "62%", "78%", "91%"],
      "type": "multiple_choice",
    },
    {
      "id": 5,
      "question":
          "Push notifications are essential for time-sensitive challenge alerts.",
      "options": ["True", "False"],
      "type": "true_false",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = _quizQuestions[currentQuestionIndex];
    final selectedAnswer = selectedAnswers[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question progress indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${_quizQuestions.length}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${selectedAnswers.length}/${_quizQuestions.length} answered',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Progress bar
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / _quizQuestions.length,
          backgroundColor: theme.colorScheme.surface,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          minHeight: 1.h,
          borderRadius: BorderRadius.circular(4),
        ),

        SizedBox(height: 4.h),

        // Question card
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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: question['type'] == 'true_false'
                          ? 'check_circle'
                          : 'quiz',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      question['type'] == 'true_false'
                          ? 'True/False'
                          : 'Multiple Choice',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              Text(
                question['question'] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Answer options
        ...((question['options'] as List).asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value as String;
          final isSelected = selectedAnswer == option;

          return Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: InkWell(
              onTap: () => onAnswerSelected(currentQuestionIndex, option),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        option,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList()),

        SizedBox(height: 2.h),


        // Navigation buttons
        Row(
          children: [
            if (currentQuestionIndex > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPreviousQuestion,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text('Previous'),
                ),
              ),

            if (currentQuestionIndex > 0) SizedBox(width: 3.w),

            if (currentQuestionIndex < _quizQuestions.length - 1)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedAnswer != null ? onNextQuestion : null,
                  icon: CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text('Next'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
