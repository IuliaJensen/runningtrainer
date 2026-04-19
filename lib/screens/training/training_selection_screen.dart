import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class TrainingSelectionScreen extends StatelessWidget {
  const TrainingSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str('training_title'),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                str('training_subtitle'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xFF666666)),
              ),
              const SizedBox(height: 32),
              _TrainingCard(
                emoji: '⏱️',
                label: str('model_minutes'),
                desc: str('model_minutes_desc'),
                onTap: () => context.push('/training/minutes'),
                accent: primary,
              ),
              const SizedBox(height: 14),
              _TrainingCard(
                emoji: '🎵',
                label: str('model_bpm'),
                desc: str('model_bpm_desc'),
                onTap: () => context.push('/training/bpm'),
                accent: primary,
              ),
              const SizedBox(height: 14),
              _TrainingCard(
                emoji: '🏃',
                label: str('model_lamppost'),
                desc: str('model_lamppost_desc'),
                onTap: () => context.push('/training/lamppost'),
                accent: primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String desc;
  final VoidCallback onTap;
  final Color accent;

  const _TrainingCard({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                        color: Color(0xFF888888), fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: const Color(0xFF444444), size: 24),
          ],
        ),
      ),
    );
  }
}
