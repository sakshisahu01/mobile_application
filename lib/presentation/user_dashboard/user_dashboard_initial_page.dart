import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/challenge_history_item_widget.dart';
import './widgets/stats_card_widget.dart';
import './widgets/streak_card_widget.dart';
import './widgets/upcoming_challenge_card_widget.dart';

class UserDashboardInitialPage extends StatefulWidget {
  const UserDashboardInitialPage({Key? key}) : super(key: key);

  @override
  State<UserDashboardInitialPage> createState() =>
      _UserDashboardInitialPageState();
}

class _UserDashboardInitialPageState extends State<UserDashboardInitialPage> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "userId": "user_12345",
    "username": "FlashMaster",
    "avatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1311bae8f-1763293463780.png",
    "avatarSemanticLabel":
        "Profile photo of a young man with short brown hair wearing a blue t-shirt",
    "streakCount": 12,
    "currentMultiplier": 2.2,
    "coinBalance": 3450,
    "xpPoints": 8750,
    "currentLevel": 15,
    "xpToNextLevel": 1250,
    "totalChallengesCompleted": 87,
    "isOnline": true,
  };

  final Map<String, dynamic> upcomingChallenge = {
    "challengeId": "ch_789",
    "type": "quiz",
    "title": "Tech Trivia Challenge",
    "description": "Test your knowledge on latest tech trends",
    "scheduledTime": DateTime.now().add(Duration(hours: 2, minutes: 15)),
    "duration": 15,
    "potentialReward": 250,
    "difficulty": "medium",
  };

  final List<Map<String, dynamic>> recentAchievements = [
    {
      "badgeId": "badge_001",
      "name": "Week Warrior",
      "icon": "emoji_events",
      "color": 0xFFFFD700,
      "earnedDate": DateTime.now().subtract(Duration(hours: 3)),
      "isNew": true,
    },
    {
      "badgeId": "badge_002",
      "name": "Speed Demon",
      "icon": "flash_on",
      "color": 0xFFFF6B35,
      "earnedDate": DateTime.now().subtract(Duration(days: 1)),
      "isNew": false,
    },
    {
      "badgeId": "badge_003",
      "name": "Quiz Master",
      "icon": "school",
      "color": 0xFF4ECDC4,
      "earnedDate": DateTime.now().subtract(Duration(days: 2)),
      "isNew": false,
    },
    // New demo achievements
    {
      "badgeId": "badge_004",
      "name": "Speed Runner",
      "icon": "whatshot",
      "color": 0xFF9B59FF,
      "earnedDate": DateTime.now().subtract(Duration(hours: 6)),
      "isNew": true,
    },
    {
      "badgeId": "badge_005",
      "name": "Consistent Player",
      "icon": "calendar_today",
      "color": 0xFF7A39FF,
      "earnedDate": DateTime.now().subtract(Duration(days: 3)),
      "isNew": false,
    },
    {
      "badgeId": "badge_006",
      "name": "Top Scorer",
      "icon": "star",
      "color": 0xFF6D2DFF,
      "earnedDate": DateTime.now().subtract(Duration(days: 4)),
      "isNew": false,
    },
  ];

  final List<Map<String, dynamic>> challengeHistory = [
    {
      "challengeId": "ch_786",
      "type": "video",
      "title": "Product Pitch Challenge",
      "completedDate": DateTime.now().subtract(Duration(hours: 5)),
      "score": 92,
      "coinsEarned": 320,
      "xpEarned": 450,
      "multiplier": 2.1,
    },
    {
      "challengeId": "ch_785",
      "type": "quiz",
      "title": "History Quiz",
      "completedDate": DateTime.now().subtract(Duration(days: 1)),
      "score": 85,
      "coinsEarned": 280,
      "xpEarned": 380,
      "multiplier": 2.0,
    },
    {
      "challengeId": "ch_784",
      "type": "prediction",
      "title": "Crypto Market Prediction",
      "completedDate": DateTime.now().subtract(Duration(days: 2)),
      "score": 78,
      "coinsEarned": 240,
      "xpEarned": 320,
      "multiplier": 1.9,
    },
  ];

  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  void _navigateToLiveChallenge() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/live-challenge-screen');
  }

  void _navigateToChallengeLibrary() {
    // Navigate to practice mode
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/quiz-challenge-interface');
  }

  void _shareAchievement(Map<String, dynamic> achievement) {
    // Share achievement to social media
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${achievement["name"]} achievement...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: Row(
              children: [
                CustomImageWidget(
                  imageUrl: userData["avatar"],
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                  semanticLabel: userData["avatarSemanticLabel"],
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        userData["username"],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'notifications',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 2.w),
            ],
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Streak Card
                StreakCardWidget(
                  streakCount: userData["streakCount"],
                  currentMultiplier: userData["currentMultiplier"],
                ),
                SizedBox(height: 2.h),

                // Stats Cards Row
                Row(
                  children: [
                    Expanded(
                      child: StatsCardWidget(
                        title: 'Coins',
                        value: userData["coinBalance"].toString(),
                        icon: 'monetization_on',
                        iconColor: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: StatsCardWidget(
                        title: 'Level ${userData["currentLevel"]}',
                        value: '${userData["xpPoints"]} XP',
                        icon: 'trending_up',
                        iconColor: theme.colorScheme.primary,
                        progress:
                            userData["xpPoints"] /
                            (userData["xpPoints"] + userData["xpToNextLevel"]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Total Challenges Card
                StatsCardWidget(
                  title: 'Total Challenges',
                  value: userData["totalChallengesCompleted"].toString(),
                  icon: 'emoji_events',
                  iconColor: Color(0xFFFFD700),
                ),
                SizedBox(height: 3.h),

                // Upcoming Challenge Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Challenge',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToChallengeLibrary,
                      child: Text('Practice'),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                UpcomingChallengeCardWidget(
                  challenge: upcomingChallenge,
                  onGetReady: _navigateToLiveChallenge,
                ),
                SizedBox(height: 3.h),

                // Recent Achievements Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Achievements',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: Text('View All')),
                  ],
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  height: 12.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentAchievements.length,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      return AchievementBadgeWidget(
                        achievement: recentAchievements[index],
                        onShare: () =>
                            _shareAchievement(recentAchievements[index]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 3.h),

                // Challenge History Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Challenge History',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed('/results-screen');
                      },
                      child: Text('View All'),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                // Challenge History List
                ...challengeHistory
                    .map(
                      (challenge) => Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: ChallengeHistoryItemWidget(
                          challenge: challenge,
                          onShare: () => _shareAchievement(challenge),
                        ),
                      ),
                    )
                    .toList(),

                SizedBox(height: 10.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
