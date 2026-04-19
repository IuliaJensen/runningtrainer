import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../../widgets/onboarding_widgets.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final current = provider.profile.goal;

    final goals = [
      (RunningGoal.fitness, '💪', str('goal_fitness'), str('goal_fitness_sub')),
      (RunningGoal.k5, '5K', str('goal_5k'), str('goal_5k_sub')),
      (RunningGoal.k10, '10K', str('goal_10k'), str('goal_10k_sub')),
      (RunningGoal.halfMarathon, '½M', str('goal_half'), str('goal_half_sub')),
      (RunningGoal.marathon, '42K', str('goal_marathon'), str('goal_marathon_sub')),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingProgress(step: 3, total: 3),
              const SizedBox(height: 32),
              Text(str('goal_title'),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                str('goal_subtitle'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xFF666666)),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: goals.map((g) {
                      final (goal, icon, label, desc) = g;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SelectCard(
                          icon: icon,
                          label: label,
                          desc: desc,
                          selected: current == goal,
                          onTap: () => context.read<UserProvider>().setGoal(goal),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await context.read<UserProvider>().completeOnboarding();
                  if (context.mounted) context.go('/home');
                },
                child: Text(
                  provider.profile.locale == AppLocale.danish
                      ? 'Kom i gang!'
                      : "Let's go!",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
