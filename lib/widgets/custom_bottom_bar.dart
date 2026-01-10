import 'package:flutter/material.dart';

/// Custom bottom navigation bar widget for FlashHustle application.
/// Implements thumb-reach optimized navigation with fixed type for consistent layout.
///
/// This widget is parameterized and reusable across different implementations.
/// Navigation logic should be handled by the parent widget.
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: theme.unselectedWidgetColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined, size: 24),
          activeIcon: Icon(Icons.dashboard, size: 24),
          label: 'Dashboard',
          tooltip: 'View your stats and upcoming challenges',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline, size: 24),
          activeIcon: Icon(Icons.play_circle, size: 24),
          label: 'Challenge',
          tooltip: 'Start a new challenge',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard_outlined, size: 24),
          activeIcon: Icon(Icons.leaderboard, size: 24),
          label: 'Leaderboard',
          tooltip: 'Check rankings and compete',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined, size: 24),
          activeIcon: Icon(Icons.account_balance_wallet, size: 24),
          label: 'Wallet',
          tooltip: 'View rewards and redemption',
        ),
      ],
    );
  }
}
