import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Transaction item widget for displaying individual transaction details
class TransactionItemWidget extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionItemWidget({Key? key, required this.transaction})
    : super(key: key);

  @override
  State<TransactionItemWidget> createState() => _TransactionItemWidgetState();
}

class _TransactionItemWidgetState extends State<TransactionItemWidget> {
  bool _isExpanded = false;

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }

  Color _getStatusColor(BuildContext context, String status) {
    final theme = Theme.of(context);
    switch (status) {
      case 'completed':
        return theme.colorScheme.primary;
      case 'bonus':
        return theme.colorScheme.tertiary;
      case 'redeemed':
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = widget.transaction["amount"] as int;
    final isPositive = amount > 0;
    final multipliers = (widget.transaction["multipliers"] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          setState(() => _isExpanded = !_isExpanded);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        context,
                        widget.transaction["status"] as String,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: widget.transaction["icon"] as String,
                      color: _getStatusColor(
                        context,
                        widget.transaction["status"] as String,
                      ),
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Transaction Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transaction["type"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _getTimeAgo(widget.transaction["date"] as DateTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${isPositive ? '+' : ''}$amount',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isPositive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'monetization_on',
                            color: isPositive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                            size: 16,
                          ),
                        ],
                      ),
                      if (multipliers.isNotEmpty) ...[
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'trending_up',
                                color: theme.colorScheme.tertiary,
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${multipliers.length}x',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(width: 2.w),

                  // Expand Icon
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),

              // Expanded Details
              if (_isExpanded) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (multipliers.isNotEmpty) ...[
                        Text(
                          'Multipliers Applied',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ...(multipliers.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 0.5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${entry.key[0].toUpperCase()}${entry.key.substring(1)}:',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  '${entry.value}x',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList()),
                        SizedBox(height: 1.h),
                        Divider(),
                        SizedBox(height: 0.5.h),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaction ID:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            widget.transaction["id"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      if (widget.transaction["redemptionDetails"] != null) ...[
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Details:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              widget.transaction["redemptionDetails"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
