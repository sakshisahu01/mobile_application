import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Submission Button Widget - Challenge submission with loading states
class SubmissionButtonWidget extends StatelessWidget {
  final bool canSubmit;
  final bool isSubmitting;
  final bool hasSubmitted;
  final VoidCallback onSubmit;

  const SubmissionButtonWidget({
    Key? key,
    required this.canSubmit,
    required this.isSubmitting,
    required this.hasSubmitted,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (hasSubmitted) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: Color(0xFF059669).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF059669), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Color(0xFF059669),
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Challenge Submitted!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Color(0xFF059669),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Submission requirements
        if (!canSubmit)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            margin: EdgeInsets.only(bottom: 2.h),
            decoration: BoxDecoration(
              color: Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFF59E0B), width: 1),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Complete the challenge to submit',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Submit button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: canSubmit && !isSubmitting ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              disabledBackgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: canSubmit ? 4 : 0,
            ),
            child: isSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Submitting...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'send',
                        color: canSubmit
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Submit Challenge',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: canSubmit
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        // Submission info
        if (canSubmit && !isSubmitting)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'Review your answers before submitting',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
