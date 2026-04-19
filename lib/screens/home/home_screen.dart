import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../../services/bpm_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting(BuildContext context, UserProvider provider) {
    final hour = DateTime.now().hour;
    if (hour < 12) return provider.str('home_greeting_morning');
    if (hour < 17) return provider.str('home_greeting_afternoon');
    return provider.str('home_greeting_evening');
  }

  String _levelLabel(RunningLevel level, UserProvider p) {
    switch (level) {
      case RunningLevel.beginner:
        return p.str('level_beginner');
      case RunningLevel.intermediate:
        return p.str('level_intermediate');
      case RunningLevel.experienced:
        return p.str('level_experienced');
    }
  }

  String _goalLabel(RunningGoal goal, UserProvider p) {
    switch (goal) {
      case RunningGoal.fitness:
        return p.str('goal_fitness');
      case RunningGoal.k5:
        return p.str('goal_5k');
      case RunningGoal.k10:
        return p.str('goal_10k');
      case RunningGoal.halfMarathon:
        return p.str('goal_half');
      case RunningGoal.marathon:
        return p.str('goal_marathon');
    }
  }

  String _recommendedModel(RunningLevel level, UserProvider p) {
    switch (level) {
      case RunningLevel.beginner:
        return p.str('model_lamppost');
      case RunningLevel.intermediate:
        return p.str('model_minutes');
      case RunningLevel.experienced:
        return p.str('model_bpm');
    }
  }

  String _todayTip(RunningLevel level, String locale) {
    final da = {
      RunningLevel.beginner: '💡 Start med 20 min. Løb til du er lidt forpustet, gå til du restituerer, gentag.',
      RunningLevel.intermediate: '💡 Prøv 4×4-intervaller i dag: 4 min hårdt løb, 4 min let jogging.',
      RunningLevel.experienced: '💡 Husk zone 2-løb – 80% af din træning skal foregå i roligt tempo.',
    };
    final en = {
      RunningLevel.beginner: '💡 Start with 20 min. Run until slightly breathless, walk to recover, repeat.',
      RunningLevel.intermediate: '💡 Try 4×4 intervals today: 4 min hard run, 4 min easy jog.',
      RunningLevel.experienced: '💡 Remember zone 2 running – 80% of training should be at easy pace.',
    };
    return (locale == 'da' ? da : en)[level]!;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final profile = provider.profile;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(context, provider),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_levelLabel(profile.level, provider)} · ${_goalLabel(profile.goal, provider)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: const Color(0xFF666666)),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.directions_run, color: primary, size: 26),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Streak + stats row
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      value: profile.currentStreak.toString(),
                      label: str('home_streak'),
                      icon: Icons.local_fire_department,
                      iconColor: const Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      value: profile.completedSessions.length.toString(),
                      label: str('home_sessions'),
                      icon: Icons.check_circle,
                      iconColor: primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      value: provider.sessionsThisWeek.toString(),
                      label: provider.profile.locale == AppLocale.danish
                          ? 'uge'
                          : 'week',
                      icon: Icons.calendar_today,
                      iconColor: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Today's recommendation card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary.withOpacity(0.25),
                      primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      str('home_recommendation'),
                      style: const TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 12,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _recommendedModel(profile.level, provider),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      BpmService.getTargetPace(profile.level, profile.goal),
                      style: const TextStyle(
                          color: Color(0xFF888888), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/training'),
                        child: Text(str('home_quick_start')),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Coach tip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🏃', style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            str('home_tip_title'),
                            style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 11,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _todayTip(
                                profile.level, profile.locale.code),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
