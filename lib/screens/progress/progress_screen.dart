import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  XFile? _garminImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _garminImage = image);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final profile = provider.profile;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    final badges = _allBadges(str);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str('progress_title'),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 24),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: _BigStat(
                      value: profile.completedSessions.length.toString(),
                      label: str('progress_sessions'),
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BigStat(
                      value: profile.currentStreak.toString(),
                      label: '${str('progress_streak')} (${str('progress_days')})',
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Weekly activity
              Text(
                str('progress_this_week'),
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _WeeklyChart(
                sessions: profile.completedSessions,
                primary: primary,
                surface: surface,
              ),

              const SizedBox(height: 28),

              // Garmin upload
              Text(
                str('garmin_title'),
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _garminImage != null
                          ? primary
                          : const Color(0xFF2A2A2A),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _garminImage == null
                      ? Row(
                          children: [
                            Icon(Icons.upload_file,
                                color: primary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(str('garmin_upload'),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(str('garmin_tip'),
                                      style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 12,
                                          height: 1.3)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(Icons.check_circle, color: primary),
                            const SizedBox(width: 12),
                            Text(
                              provider.profile.locale.code == 'da'
                                  ? 'Skærmbillede uploadet ✓'
                                  : 'Screenshot uploaded ✓',
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _garminImage = null),
                              child: const Text('×',
                                  style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 20)),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 28),

              // Badges
              Text(
                str('progress_badges_title'),
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              if (profile.earnedBadges.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      str('progress_no_badges'),
                      style: const TextStyle(
                          color: Color(0xFF555555), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: badges.where((b) {
                    return profile.earnedBadges.contains(b.id);
                  }).map((b) {
                    return _BadgeTile(badge: b, primary: primary, surface: surface);
                  }).toList(),
                ),

              if (profile.earnedBadges.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  provider.profile.locale.code == 'da'
                      ? 'Låsede badges'
                      : 'Locked badges',
                  style: const TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: badges.where((b) {
                    return !profile.earnedBadges.contains(b.id);
                  }).map((b) {
                    return _BadgeTile(
                        badge: b,
                        primary: const Color(0xFF333333),
                        surface: const Color(0xFF0F0F0F),
                        locked: true);
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<_Badge> _allBadges(String Function(String) str) => [
        _Badge('first_run', '🏅', str('badge_first_run'), str('badge_first_run_desc')),
        _Badge('five_runs', '⭐', str('badge_five_runs'), str('badge_five_runs_desc')),
        _Badge('ten_runs', '🌟', str('badge_ten_runs'), str('badge_ten_runs_desc')),
        _Badge('streak_3', '🔥', str('badge_streak_3'), str('badge_streak_3_desc')),
        _Badge('streak_7', '🏆', str('badge_streak_7'), str('badge_streak_7_desc')),
      ];
}

class _Badge {
  final String id;
  final String emoji;
  final String label;
  final String desc;
  const _Badge(this.id, this.emoji, this.label, this.desc);
}

class _BadgeTile extends StatelessWidget {
  final _Badge badge;
  final Color primary;
  final Color surface;
  final bool locked;

  const _BadgeTile({
    required this.badge,
    required this.primary,
    required this.surface,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: locked ? const Color(0xFF1A1A1A) : primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            locked ? '🔒' : badge.emoji,
            style: TextStyle(fontSize: locked ? 20 : 28),
          ),
          const SizedBox(height: 6),
          Text(
            badge.label,
            style: TextStyle(
              color: locked ? const Color(0xFF444444) : Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _BigStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<String> sessions;
  final Color primary;
  final Color surface;

  const _WeeklyChart({
    required this.sessions,
    required this.primary,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      return (d, sessions.contains(key));
    });

    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final daDayLabels = ['M', 'T', 'O', 'T', 'F', 'L', 'S'];

    final locale = context.read<UserProvider>().profile.locale.code;
    final labels = locale == 'da' ? daDayLabels : dayLabels;

    return Row(
      children: List.generate(7, (i) {
        final (date, hasSession) = days[i];
        final isToday = date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;
        final dotColor = hasSession
            ? primary
            : isToday
                ? primary.withOpacity(0.3)
                : const Color(0xFF2A2A2A);

        return Expanded(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: isToday && !hasSession
                      ? Border.all(color: primary, width: 1)
                      : null,
                ),
                child: hasSession
                    ? const Center(
                        child: Icon(Icons.check, color: Colors.black, size: 16))
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                labels[date.weekday - 1],
                style: TextStyle(
                  color: isToday ? primary : const Color(0xFF555555),
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
