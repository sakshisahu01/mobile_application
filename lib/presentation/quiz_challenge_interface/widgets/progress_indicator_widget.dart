import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Progress Indicator Widget
/// Shows visual progress through quiz questions
class ProgressIndicatorWidget extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final List<int> answeredQuestions;
  final Function(int) onQuestionTap;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.onQuestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalQuestions, (index) {
          final isAnswered = answeredQuestions.contains(index);
          final isCurrent = index == currentIndex;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: GestureDetector(
              onTap: () => onQuestionTap(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: isCurrent ? 12.w : 8.w,
                height: 8,
                decoration: BoxDecoration(
                  color: isAnswered
                      ? theme.colorScheme.primary
                      : isCurrent
                      ? theme.colorScheme.primary.withValues(alpha: 0.5)
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
