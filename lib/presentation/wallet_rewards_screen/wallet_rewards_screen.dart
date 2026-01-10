import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/balance_card_widget.dart';
import './widgets/reward_card_widget.dart';
import './widgets/transaction_item_widget.dart';

/// Wallet & Rewards Screen - Content widget for tab navigation
/// Manages earned coins, XP tracking, and reward redemption
class WalletRewardsScreen extends StatefulWidget {
  const WalletRewardsScreen({Key? key}) : super(key: key);

  @override
  State<WalletRewardsScreen> createState() => _WalletRewardsScreenState();
}

class _WalletRewardsScreenState extends State<WalletRewardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  bool _isRefreshing = false;

  // Mock data for wallet balance
  final Map<String, dynamic> walletData = {
    "coins": 2847,
    "xp": 15420,
    "level": 12,
    "nextLevelXp": 18000,
    "lastUpdated": DateTime.now().subtract(Duration(minutes: 5)),
  };

  // Mock transaction history
  final List<Map<String, dynamic>> transactions = [
    {
      "id": "txn_001",
      "type": "Quiz Challenge",
      "icon": "quiz",
      "date": DateTime.now().subtract(Duration(hours: 2)),
      "amount": 150,
      "multipliers": {"streak": 2.5, "speed": 1.5, "difficulty": 1.2},
      "status": "completed",
    },
    {
      "id": "txn_002",
      "type": "Video Pitch",
      "icon": "videocam",
      "date": DateTime.now().subtract(Duration(days: 1)),
      "amount": 300,
      "multipliers": {"streak": 2.4, "quality": 1.8},
      "status": "completed",
    },
    {
      "id": "txn_003",
      "type": "Prediction Challenge",
      "icon": "trending_up",
      "date": DateTime.now().subtract(Duration(days: 1, hours: 12)),
      "amount": 200,
      "multipliers": {"streak": 2.3, "accuracy": 1.6},
      "status": "completed",
    },
    {
      "id": "txn_004",
      "type": "Streak Bonus",
      "icon": "local_fire_department",
      "date": DateTime.now().subtract(Duration(days: 2)),
      "amount": 500,
      "multipliers": {"milestone": 3.0},
      "status": "bonus",
    },
    {
      "id": "txn_005",
      "type": "Cash Redemption",
      "icon": "payments",
      "date": DateTime.now().subtract(Duration(days: 3)),
      "amount": -1000,
      "multipliers": {},
      "status": "redeemed",
      "redemptionDetails": "PayPal - \$10.00",
    },
    {
      "id": "txn_006",
      "type": "Quiz Challenge",
      "icon": "quiz",
      "date": DateTime.now().subtract(Duration(days: 3, hours: 8)),
      "amount": 120,
      "multipliers": {"streak": 2.2, "speed": 1.3},
      "status": "completed",
    },
  ];

  // Mock available rewards
  final List<Map<String, dynamic>> availableRewards = [
    {
      "id": "reward_001",
      "type": "cash",
      "title": "\$5 Cash Payout",
      "description": "Instant transfer to PayPal or bank account",
      "minCoins": 500,
      "value": 5.0,
      "icon": "account_balance_wallet",
      "expiresIn": null,
      "image":
          "https://images.unsplash.com/photo-1601144674842-a609984223bf",
      "semanticLabel":
          "Stack of US dollar bills with Benjamin Franklin visible on top bill",
    },
    {
      "id": "reward_002",
      "type": "cash",
      "title": "\$10 Cash Payout",
      "description": "Instant transfer to PayPal or bank account",
      "minCoins": 1000,
      "value": 10.0,
      "icon": "account_balance_wallet",
      "expiresIn": null,
      "image":
          "https://images.unsplash.com/photo-1662061292998-9a03e7887698",
      "semanticLabel":
          "Close-up of multiple US twenty dollar bills arranged in a fan pattern",
    },
    {
      "id": "reward_003",
      "type": "coupon",
      "title": "Amazon \$25 Gift Card",
      "description": "Digital gift card code delivered instantly",
      "minCoins": 2500,
      "value": 25.0,
      "icon": "card_giftcard",
      "expiresIn": DateTime.now().add(Duration(days: 30)),
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ef878ad8-1765219838582.png",
      "semanticLabel":
          "Amazon gift card with orange and white branding on dark background",
    },
    {
      "id": "reward_004",
      "type": "coupon",
      "title": "Starbucks \$10 Gift Card",
      "description": "Enjoy your favorite coffee on us",
      "minCoins": 1000,
      "value": 10.0,
      "icon": "local_cafe",
      "expiresIn": DateTime.now().add(Duration(days: 45)),
      "image":
          "https://images.unsplash.com/photo-1548704359-5bf126b72d32",
      "semanticLabel":
          "Starbucks coffee cup with green logo on wooden table with coffee beans",
    },
    {
      "id": "reward_005",
      "type": "premium",
      "title": "Premium Features (1 Month)",
      "description": "Unlock exclusive challenges and bonus multipliers",
      "minCoins": 1500,
      "value": 0.0,
      "icon": "workspace_premium",
      "expiresIn": null,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1cfa9a702-1767616638234.png",
      "semanticLabel":
          "Golden crown icon with sparkles on gradient purple background",
    },
    {
      "id": "reward_006",
      "type": "coupon",
      "title": "Netflix 1 Month Subscription",
      "description": "Stream unlimited movies and shows",
      "minCoins": 1200,
      "value": 15.99,
      "icon": "movie",
      "expiresIn": DateTime.now().add(Duration(days: 60)),
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ecfe12c3-1766878186896.png",
      "semanticLabel":
          "Netflix logo in red on black background with streaming content thumbnails",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  List<Map<String, dynamic>> _getFilteredTransactions() {
    if (_selectedFilter == 'All') return transactions;
    if (_selectedFilter == 'Earnings') {
      return transactions.where((t) {
        final amount = t['amount'];
        final status = t['status']?.toString();
        return (amount is num && amount > 0) && (status != 'bonus');
      }).toList();
    }
    if (_selectedFilter == 'Redemptions') {
      return transactions.where((t) {
        final status = t['status']?.toString();
        return status == 'redeemed';
      }).toList();
    }
    if (_selectedFilter == 'Bonuses') {
      return transactions.where((t) {
        final status = t['status']?.toString();
        return status == 'bonus';
      }).toList();
    }
    return transactions;
  }

  void _showRedemptionDialog(Map<String, dynamic> reward) {
    final theme = Theme.of(context);
    final bool hasEnoughCoins =
        (walletData["coins"] as int) >= (reward["minCoins"] as int);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Redeem Reward', style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward["title"] as String, style: theme.textTheme.titleMedium),
            SizedBox(height: 1.h),
            Text(
              reward["description"] as String,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Required:', style: theme.textTheme.bodyMedium),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'monetization_on',
                      color: theme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${reward["minCoins"]} coins',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!hasEnoughCoins) ...[
              SizedBox(height: 1.h),
              Text(
                'Insufficient coins. You need ${(reward["minCoins"] as int) - (walletData["coins"] as int)} more coins.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: hasEnoughCoins
                ? () {
                    Navigator.pop(context);
                    _processRedemption(reward);
                  }
                : null,
            child: Text('Redeem'),
          ),
        ],
      ),
    );
  }

  void _processRedemption(Map<String, dynamic> reward) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing redemption...'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reward redeemed successfully!'),
            backgroundColor: theme.colorScheme.primary,
            action: SnackBarAction(label: 'View', onPressed: () {}),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Custom AppBar content
        Container(
          padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 2.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Wallet & Rewards',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'lock',
                                color: theme.colorScheme.primary,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Secure',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),
                        IconButton(
                          icon: CustomIconWidget(
                            iconName: 'notifications_outlined',
                            color: theme.colorScheme.onSurface,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Wallet'),
                    Tab(text: 'Rewards'),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Wallet Tab
              RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  children: [
                    // Balance Card
                    BalanceCardWidget(
                      coins: walletData["coins"] as int,
                      xp: walletData["xp"] as int,
                      level: walletData["level"] as int,
                      nextLevelXp: walletData["nextLevelXp"] as int,
                      lastUpdated: walletData["lastUpdated"] as DateTime,
                    ),

                    SizedBox(height: 3.h),

                    // Transaction History Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction History',
                          style: theme.textTheme.titleLarge,
                        ),
                        PopupMenuButton<String>(
                          initialValue: _selectedFilter,
                          onSelected: (value) {
                            setState(() => _selectedFilter = value);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'All', child: Text('All')),
                            PopupMenuItem(
                              value: 'Earnings',
                              child: Text('Earnings'),
                            ),
                            PopupMenuItem(
                              value: 'Redemptions',
                              child: Text('Redemptions'),
                            ),
                            PopupMenuItem(
                              value: 'Bonuses',
                              child: Text('Bonuses'),
                            ),
                          ],
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _selectedFilter,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'arrow_drop_down',
                                  color: theme.colorScheme.onSurface,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Transaction List
                    if (_getFilteredTransactions().isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Column(
                            children: [
                              CustomIconWidget(
                                iconName: 'receipt_long',
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No transactions found',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _getFilteredTransactions().length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 1.h),
                        itemBuilder: (context, index) {
                          final transaction = _getFilteredTransactions()[index];
                          return TransactionItemWidget(
                            transaction: transaction,
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Rewards Tab
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                children: [
                  // Current Balance Info
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'monetization_on',
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Available: ${walletData["coins"]} coins',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text('Available Rewards', style: theme.textTheme.titleLarge),

                  SizedBox(height: 2.h),

                  // Rewards Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                    ),
                    itemCount: availableRewards.length,
                    itemBuilder: (context, index) {
                      final reward = availableRewards[index];
                      return RewardCardWidget(
                        reward: reward,
                        currentCoins: walletData["coins"] as int,
                        onRedeem: () => _showRedemptionDialog(reward),
                      );
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Redemption Info
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info_outline',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Redemption Information',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '• Cash payouts processed within 24-48 hours\n• Gift cards delivered instantly via email\n• Premium features activated immediately\n• All transactions are secure and encrypted',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
