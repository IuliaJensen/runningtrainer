import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              Text(str('settings_title'),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 28),

              _SectionHeader(label: str('settings_language')),
              const SizedBox(height: 10),
              _SegmentedRow(
                options: ['🇩🇰 Dansk', '🇬🇧 English'],
                selectedIndex: profile.locale == AppLocale.danish ? 0 : 1,
                onSelect: (i) => provider.setLocale(
                    i == 0 ? AppLocale.danish : AppLocale.english),
                primary: primary,
                surface: surface,
              ),

              const SizedBox(height: 24),
              _SectionHeader(label: str('settings_theme')),
              const SizedBox(height: 10),
              ...AppThemeVariant.values.map((v) {
                final labels = [
                  str('settings_theme_garmin'),
                  str('settings_theme_nike'),
                  str('settings_theme_sport'),
                ];
                final icons = ['🟢', '🔴', '🔵'];
                final selected = profile.themeVariant == v;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => provider.setTheme(v),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? primary.withOpacity(0.12)
                            : surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? primary
                              : const Color(0xFF2A2A2A),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(icons[v.index],
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              labels[v.index],
                              style: TextStyle(
                                color: selected ? primary : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_circle,
                                color: primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
              _SectionHeader(label: str('settings_profile')),
              const SizedBox(height: 10),

              _PickerRow(
                label: str('settings_level'),
                value: _levelLabel(profile.level, str),
                surface: surface,
                onTap: () => _showLevelSheet(context, provider, str),
              ),
              const SizedBox(height: 8),
              _PickerRow(
                label: str('settings_environment'),
                value: _envLabel(profile.environment, str),
                surface: surface,
                onTap: () => _showEnvSheet(context, provider, str),
              ),
              const SizedBox(height: 8),
              _PickerRow(
                label: str('settings_goal'),
                value: _goalLabel(profile.goal, str),
                surface: surface,
                onTap: () => _showGoalSheet(context, provider, str),
              ),

              const SizedBox(height: 32),
              TextButton(
                onPressed: () => _confirmReset(context, provider, str),
                child: Text(
                  str('settings_reset'),
                  style: const TextStyle(
                      color: Color(0xFF666666), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _levelLabel(RunningLevel l, String Function(String) str) {
    switch (l) {
      case RunningLevel.beginner:
        return str('level_beginner');
      case RunningLevel.intermediate:
        return str('level_intermediate');
      case RunningLevel.experienced:
        return str('level_experienced');
    }
  }

  String _envLabel(RunningEnvironment e, String Function(String) str) {
    switch (e) {
      case RunningEnvironment.treadmill:
        return str('env_treadmill');
      case RunningEnvironment.trail:
        return str('env_trail');
      case RunningEnvironment.road:
        return str('env_road');
    }
  }

  String _goalLabel(RunningGoal g, String Function(String) str) {
    switch (g) {
      case RunningGoal.fitness:
        return str('goal_fitness');
      case RunningGoal.k5:
        return str('goal_5k');
      case RunningGoal.k10:
        return str('goal_10k');
      case RunningGoal.halfMarathon:
        return str('goal_half');
      case RunningGoal.marathon:
        return str('goal_marathon');
    }
  }

  void _showLevelSheet(
      BuildContext ctx, UserProvider p, String Function(String) str) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PickerSheet(
        title: str('settings_level'),
        options: RunningLevel.values.map((l) {
          final labels = [
            str('level_beginner'),
            str('level_intermediate'),
            str('level_experienced'),
          ];
          return labels[l.index];
        }).toList(),
        selectedIndex: p.profile.level.index,
        onSelect: (i) => p.setLevel(RunningLevel.values[i]),
      ),
    );
  }

  void _showEnvSheet(
      BuildContext ctx, UserProvider p, String Function(String) str) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PickerSheet(
        title: str('settings_environment'),
        options: [
          str('env_treadmill'),
          str('env_trail'),
          str('env_road'),
        ],
        selectedIndex: p.profile.environment.index,
        onSelect: (i) => p.setEnvironment(RunningEnvironment.values[i]),
      ),
    );
  }

  void _showGoalSheet(
      BuildContext ctx, UserProvider p, String Function(String) str) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PickerSheet(
        title: str('settings_goal'),
        options: [
          str('goal_fitness'),
          str('goal_5k'),
          str('goal_10k'),
          str('goal_half'),
          str('goal_marathon'),
        ],
        selectedIndex: p.profile.goal.index,
        onSelect: (i) => p.setGoal(RunningGoal.values[i]),
      ),
    );
  }

  void _confirmReset(
      BuildContext ctx, UserProvider p, String Function(String) str) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(str('settings_reset'),
            style: const TextStyle(color: Colors.white)),
        content: Text(str('settings_reset_confirm'),
            style: const TextStyle(color: Color(0xFF888888))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: Text(str('settings_cancel'),
                style: const TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              p.resetProgress();
              Navigator.pop(_);
            },
            child: Text(str('settings_confirm'),
                style: const TextStyle(color: Color(0xFFFF453A))),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 11,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600),
    );
  }
}

class _SegmentedRow extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final void Function(int) onSelect;
  final Color primary;
  final Color surface;

  const _SegmentedRow({
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
    required this.primary,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final selected = i == selectedIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selected ? primary.withOpacity(0.15) : surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? primary : const Color(0xFF2A2A2A),
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Text(
                  options[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? primary : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PickerRow extends StatelessWidget {
  final String label;
  final String value;
  final Color surface;
  final VoidCallback onTap;

  const _PickerRow({
    required this.label,
    required this.value,
    required this.surface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Color(0xFF888888), fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Color(0xFF444444), size: 20),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(options.length, (i) {
              final selected = i == selectedIndex;
              return ListTile(
                title: Text(
                  options[i],
                  style: TextStyle(
                    color: selected ? primary : Colors.white,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                trailing: selected
                    ? Icon(Icons.check_circle, color: primary)
                    : null,
                onTap: () {
                  onSelect(i);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
