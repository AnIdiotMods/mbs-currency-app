import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/citizen_dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_completion_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MbsCurrencyApp());
}

class MbsCurrencyApp extends StatelessWidget {
  const MbsCurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MBS Currency',
        theme: AppTheme.dark(),
        home: const RootScreen(),
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, state, __) {
        if (!state.isAuthenticated) return const LoginScreen();
        if (state.isAdmin) return const AdminDashboardScreen();

        final citizen = state.currentCitizen;
        if (citizen == null || !citizen.isProfileComplete) {
          return const ProfileCompletionScreen();
        }

        return const CitizenDashboardScreen();
      },
    );
  }
}
