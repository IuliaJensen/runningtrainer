import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/level_screen.dart';
import 'screens/onboarding/environment_screen.dart';
import 'screens/onboarding/goal_screen.dart';
import 'screens/main_shell.dart';
import 'screens/home/home_screen.dart';
import 'screens/training/training_selection_screen.dart';
import 'screens/training/minutes_training_screen.dart';
import 'screens/training/bpm_training_screen.dart';
import 'screens/training/lamppost_training_screen.dart';
import 'screens/coach/coach_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/settings/settings_screen.dart';

class LøbecoachApp extends StatelessWidget {
  const LøbecoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        final router = GoRouter(
          initialLocation: '/splash',
          redirect: (ctx, state) {
            final onboarded = provider.profile.onboardingComplete;
            final loc = state.matchedLocation;
            if (loc == '/splash') return null;
            if (!onboarded && !loc.startsWith('/onboarding')) {
              return '/onboarding/welcome';
            }
            if (onboarded && loc.startsWith('/onboarding')) return '/home';
            return null;
          },
          routes: [
            GoRoute(
              path: '/splash',
              builder: (_, __) => const SplashScreen(),
            ),
            GoRoute(
              path: '/onboarding/welcome',
              builder: (_, __) => const WelcomeScreen(),
            ),
            GoRoute(
              path: '/onboarding/level',
              builder: (_, __) => const LevelScreen(),
            ),
            GoRoute(
              path: '/onboarding/environment',
              builder: (_, __) => const EnvironmentScreen(),
            ),
            GoRoute(
              path: '/onboarding/goal',
              builder: (_, __) => const GoalScreen(),
            ),
            ShellRoute(
              builder: (_, state, child) => MainShell(
                location: state.matchedLocation,
                child: child,
              ),
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (_, __) => const HomeScreen(),
                ),
                GoRoute(
                  path: '/training',
                  builder: (_, __) => const TrainingSelectionScreen(),
                ),
                GoRoute(
                  path: '/coach',
                  builder: (_, __) => const CoachScreen(),
                ),
                GoRoute(
                  path: '/progress',
                  builder: (_, __) => const ProgressScreen(),
                ),
                GoRoute(
                  path: '/settings',
                  builder: (_, __) => const SettingsScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/training/minutes',
              builder: (_, __) => const MinutesTrainingScreen(),
            ),
            GoRoute(
              path: '/training/bpm',
              builder: (_, __) => const BpmTrainingScreen(),
            ),
            GoRoute(
              path: '/training/lamppost',
              builder: (_, __) => const LamppostTrainingScreen(),
            ),
          ],
        );

        return MaterialApp.router(
          title: provider.str('appTitle'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(provider.profile.themeVariant),
          routerConfig: router,
        );
      },
    );
  }
}
