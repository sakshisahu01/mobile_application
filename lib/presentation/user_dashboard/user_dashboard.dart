import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_bar.dart';
import './user_dashboard_initial_page.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  UserDashboardState createState() => UserDashboardState();
}

class UserDashboardState extends State<UserDashboard> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;

  // ALL CustomBottomBar routes in EXACT order matching CustomBottomBar items
  final List<String> routes = [
    '/user-dashboard',
    '/live-challenge-screen',
    '/leaderboard-screen',
    '/wallet-rewards-screen',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['initialIndex'] is int) {
      final newIndex = args['initialIndex'] as int;
      if (newIndex != currentIndex) {
        setState(() => currentIndex = newIndex);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null && routes.length > newIndex) {
            navigatorKey.currentState!.pushReplacementNamed(routes[newIndex]);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: '/user-dashboard',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/user-dashboard':
            case '/':
              return MaterialPageRoute(
                builder: (context) => const UserDashboardInitialPage(),
                settings: settings,
              );
            default:
              // Check AppRoutes.routes for all other routes
              if (AppRoutes.routes.containsKey(settings.name)) {
                return MaterialPageRoute(
                  builder: AppRoutes.routes[settings.name]!,
                  settings: settings,
                );
              }
              return null;
          }
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // For the routes that are not in the AppRoutes.routes, do not navigate to them.
          if (!AppRoutes.routes.containsKey(routes[index])) {
            return;
          }
          if (currentIndex != index) {
            setState(() => currentIndex = index);
            navigatorKey.currentState?.pushReplacementNamed(routes[index]);
          }
        },
      ),
    );
  }
}
