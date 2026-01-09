import 'package:flutter/material.dart';
import '../presentation/results_screen/results_screen.dart';
import '../presentation/quiz_challenge_interface/quiz_challenge_interface.dart';
import '../presentation/live_challenge_screen/live_challenge_screen.dart';
import '../presentation/user_dashboard/user_dashboard.dart';
import '../presentation/prediction_challenge_screen/prediction_challenge_screen.dart';
import '../presentation/wallet_rewards_screen/wallet_rewards_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String results = '/results-screen';
  static const String quizChallengeInterface = '/quiz-challenge-interface';
  static const String liveChallenge = '/live-challenge-screen';
  static const String userDashboard = '/user-dashboard';
  static const String predictionChallenge = '/prediction-challenge-screen';
  static const String walletRewards = '/wallet-rewards-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const UserDashboard(),
    results: (context) => const ResultsScreen(),
    quizChallengeInterface: (context) => const QuizChallengeInterface(),
    liveChallenge: (context) => const LiveChallengeScreen(),
    userDashboard: (context) => const UserDashboard(),
    predictionChallenge: (context) => const PredictionChallengeScreen(),
    walletRewards: (context) => const WalletRewardsScreen(),
    // TODO: Add your other routes here
  };
}
