import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../../widgets/onboarding_widgets.dart';

class EnvironmentScreen extends StatelessWidget {
  const EnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final current = provider.profile.environment;

    final envs = [
      (RunningEnvironment.treadmill, '🏋️', str('env_treadmill'), str('env_treadmill_desc')),
      (RunningEnvironment.trail, '🌲', str('env_trail'), str('env_trail_desc')),
      (RunningEnvironment.road, '🏙️', str('env_road'), str('env_road_desc')),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingProgress(step: 2, total: 3),
              const SizedBox(height: 32),
              Text(str('environment_title'),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                str('environment_subtitle'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xFF666666)),
              ),
              const SizedBox(height: 32),
              ...envs.map((e) {
                final (env, icon, label, desc) = e;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SelectCard(
                    icon: icon,
                    label: label,
                    desc: desc,
                    selected: current == env,
                    onTap: () =>
                        context.read<UserProvider>().setEnvironment(env),
                  ),
                );
              }),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/onboarding/goal'),
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
