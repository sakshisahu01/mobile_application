import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

/// Reward card widget for displaying available rewards
class RewardCardWidget extends StatelessWidget {
  final Map<String, dynamic> reward;
  final int currentCoins;
  final VoidCallback onRedeem;

  const RewardCardWidget({
    Key? key,
    required this.reward,
    required this.currentCoins,
    required this.onRedeem,
  }) : super(key: key);

  String _getExpiryText(DateTime? expiresIn) {
    if (expiresIn == null) return 'No expiry';
    final difference = expiresIn.difference(DateTime.now());
    if (difference.inDays > 30)
      return 'Expires in ${(difference.inDays / 30).floor()} months';
    if (difference.inDays > 0) return 'Expires in ${difference.inDays} days';
    return 'Expires soon';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minCoins = reward["minCoins"] as int;
    final hasEnoughCoins = currentCoins >= minCoins;
    final type = reward["type"] as String;

    Color getTypeColor() {
      switch (type) {
        case 'cash':
          return theme.colorScheme.primary;
        case 'coupon':
          return theme.colorScheme.secondary;
        case 'premium':
          return theme.colorScheme.tertiary;
        default:
          return theme.colorScheme.onSurfaceVariant;
      }
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: reward["image"] as String,
                  width: double.infinity,
                  height: 15.h,
                  fit: BoxFit.cover,
                  semanticLabel: reward["semanticLabel"] as String,
                ),
              ),
              if (reward["expiresIn"] != null)
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _getExpiryText(reward["expiresIn"] as DateTime?),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: getTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: getTypeColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Title
                  Text(
                    reward["title"] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.5.h),

                  // Description
                  Text(
                    reward["description"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Spacer(),

                  // Cost
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'monetization_on',
                        color: hasEnoughCoins
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$minCoins',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: hasEnoughCoins
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Redeem Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: hasEnoughCoins ? onRedeem : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        hasEnoughCoins ? 'Redeem' : 'Locked',
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
