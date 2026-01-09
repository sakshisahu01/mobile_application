import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/breakdown_card_widget.dart';
import './widgets/challenge_feedback_widget.dart';
import './widgets/leaderboard_position_widget.dart';
import './widgets/score_hero_widget.dart';
import 'widgets/achievement_badges_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/breakdown_card_widget.dart';
import 'widgets/challenge_feedback_widget.dart';
import 'widgets/leaderboard_position_widget.dart';
import 'widgets/score_hero_widget.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _celebrationController;
  late AnimationController _scoreController;
  late AnimationController _breakdownController;

  // Mock result data
  final Map<String, dynamic> resultData = {
    "totalScore": 850,
    "coinsEarned": 120,
    "xpEarned": 450,
    "basePoints": 500,
    "streakMultiplier": 2.5,
    "speedBonus": 1.5,
    "difficultyMultiplier": 1.2,
    "submittedInTime": true,
    "challengeType": "quiz",
    "correctAnswers": 8,
    "totalQuestions": 10,
    "accuracy": 80,
    "currentStreak": 15,
    "previousRank": 245,
    "currentRank": 198,
    "newBadges": [
      {
        "id": 1,
        "name": "Speed Demon",
        "description": "Completed challenge in under 5 minutes",
        "icon": "https://img.rocket.new/generatedImages/rocket_gen_img_1dc244bee-1767978055910.png",
        "semanticLabel": "Gold lightning bolt badge with sparkles",
        "rarity": "rare",
      },
      {
        "id": 2,
        "name": "Streak Master",
        "description": "Maintained 15-day streak",
        "icon": "https://img.rocket.new/generatedImages/rocket_gen_img_1f1c35e66-1767978057234.png",
        "semanticLabel": "Orange flame badge with number 15",
        "rarity": "epic",
      },
    ],
    "quizFeedback": [
      {
        "question": "What is the capital of France?",
        "userAnswer": "Paris",
        "correctAnswer": "Paris",
        "isCorrect": true,
        "explanation": "Paris has been the capital of France since 987 AD.",
      },
      {
        "question": "Which planet is closest to the Sun?",
        "userAnswer": "Venus",
        "correctAnswer": "Mercury",
        "isCorrect": false,
        "explanation":
            "Mercury is the closest planet to the Sun, orbiting at an average distance of 57.9 million km.",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _triggerHapticFeedback();
  }

  void _initializeAnimations() {
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _breakdownController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _celebrationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _scoreController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _breakdownController.forward();
    });
  }

  void _triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.lightImpact();
    });
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _scoreController.dispose();
    _breakdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Hero section with score and rewards
              ScoreHeroWidget(
                totalScore: resultData["totalScore"] as int,
                coinsEarned: resultData["coinsEarned"] as int,
                xpEarned: resultData["xpEarned"] as int,
                scoreController: _scoreController,
              ),

              SizedBox(height: 3.h),

              // Breakdown cards
              BreakdownCardWidget(
                basePoints: resultData["basePoints"] as int,
                streakMultiplier: resultData["streakMultiplier"] as double,
                speedBonus: resultData["speedBonus"] as double,
                difficultyMultiplier:
                    resultData["difficultyMultiplier"] as double,
                submittedInTime: resultData["submittedInTime"] as bool,
                breakdownController: _breakdownController,
              ),

              SizedBox(height: 3.h),

              // Challenge-specific feedback
              ChallengeFeedbackWidget(
                challengeType: resultData["challengeType"] as String,
                correctAnswers: resultData["correctAnswers"] as int,
                totalQuestions: resultData["totalQuestions"] as int,
                accuracy: resultData["accuracy"] as int,
                quizFeedback: (resultData["quizFeedback"] as List)
                    .cast<Map<String, dynamic>>(),
              ),

              SizedBox(height: 3.h),

              // Achievement badges
              AchievementBadgesWidget(
                newBadges: (resultData["newBadges"] as List)
                    .cast<Map<String, dynamic>>(),
                celebrationController: _celebrationController,
              ),

              SizedBox(height: 3.h),

              // Leaderboard position update
              LeaderboardPositionWidget(
                previousRank: resultData["previousRank"] as int,
                currentRank: resultData["currentRank"] as int,
                currentStreak: resultData["currentStreak"] as int,
              ),

              SizedBox(height: 3.h),

              // Action buttons
              ActionButtonsWidget(
                onContinue: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushReplacementNamed('/user-dashboard');
                },
                onViewLeaderboard: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/leaderboard-screen');
                },
                onChallengeFreinds: _shareResults,
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  void _shareResults() {
    HapticFeedback.selectionClick();
    // Share functionality would be implemented here
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Share functionality coming soon!',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}