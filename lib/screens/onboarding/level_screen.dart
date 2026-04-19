import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../../widgets/onboarding_widgets.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final current = provider.profile.level;

    final levels = [
      (RunningLevel.beginner, '🌱', str('level_beginner'), str('level_beginner_desc')),
      (RunningLevel.intermediate, '🏃', str('level_intermediate'), str('level_intermediate_desc')),
      (RunningLevel.experienced, '⚡', str('level_experienced'), str('level_experienced_desc')),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingProgress(step: 1, total: 3),
              const SizedBox(height: 32),
              Text(str('level_title'),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 32),
              ...levels.map((l) {
                final (level, icon, label, desc) = l;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SelectCard(
                    icon: icon,
                    label: label,
                    desc: desc,
                    selected: current == level,
                    onTap: () => context.read<UserProvider>().setLevel(level),
                  ),
                );
              }),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/onboarding/environment'),
                child: Text(
                    provider.profile.locale == AppLocale.danish ? 'Næste' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
