import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final primary = Theme.of(context).colorScheme.primary;
    final isDa = provider.profile.locale == AppLocale.danish;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.directions_run, size: 36, color: primary),
              ),
              const SizedBox(height: 32),
              Text(
                str('welcome_title'),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                str('welcome_subtitle'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF888888),
                      fontSize: 17,
                    ),
              ),
              const Spacer(flex: 3),
              Text(
                str('language_title'),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF666666),
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LangButton(
                      label: 'Dansk',
                      flag: '🇩🇰',
                      selected: isDa,
                      onTap: () => context.read<UserProvider>().setLocale(AppLocale.danish),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LangButton(
                      label: 'English',
                      flag: '🇬🇧',
                      selected: !isDa,
                      onTap: () => context.read<UserProvider>().setLocale(AppLocale.english),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/onboarding/level'),
                child: Text(str('welcome_cta')),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  const _LangButton({
    required this.label,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? primary.withOpacity(0.15) : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primary : const Color(0xFF2A2A2A),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? primary : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
