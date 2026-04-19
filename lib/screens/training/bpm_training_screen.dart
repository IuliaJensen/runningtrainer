import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../../services/bpm_service.dart';

class BpmTrainingScreen extends StatefulWidget {
  const BpmTrainingScreen({super.key});

  @override
  State<BpmTrainingScreen> createState() => _BpmTrainingScreenState();
}

class _BpmTrainingScreenState extends State<BpmTrainingScreen>
    with SingleTickerProviderStateMixin {
  bool _showExplainer = false;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final profile = provider.profile;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    final bpm = BpmService.recommendBpm(profile.level, profile.goal);
    final pace = BpmService.getTargetPace(profile.level, profile.goal);
    final songs = BpmService.getSongsNear(bpm);

    return Scaffold(
      appBar: AppBar(
        title: Text(str('bpm_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                str('bpm_explanation'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: const Color(0xFF888888)),
              ),
              const SizedBox(height: 32),

              // Big BPM display
              Center(
                child: ScaleTransition(
                  scale: _pulse,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withOpacity(0.12),
                      border: Border.all(color: primary.withOpacity(0.4), width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bpm.toString(),
                          style: TextStyle(
                            color: primary,
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'BPM',
                          style: TextStyle(
                            color: primary.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  pace,
                  style: const TextStyle(color: Color(0xFF888888), fontSize: 14),
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _showExplainer = !_showExplainer),
                  child: Text(
                    str('bpm_what_is'),
                    style: TextStyle(color: primary, fontSize: 13),
                  ),
                ),
              ),

              if (_showExplainer) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Text(
                    str('bpm_what_is_answer'),
                    style: const TextStyle(
                        color: Color(0xFFCCCCCC), fontSize: 14, height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),

              // Songs section
              Text(
                str('bpm_songs_title'),
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              if (songs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      profile.locale == AppLocale.danish
                          ? 'Ingen sange fundet ved $bpm BPM'
                          : 'No songs found at $bpm BPM',
                      style: const TextStyle(color: Color(0xFF666666)),
                    ),
                  ),
                )
              else
                ...songs.take(5).map((song) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('🎵',
                                style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                              Text(
                                song.artist,
                                style: const TextStyle(
                                    color: Color(0xFF888888), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${song.bpm} BPM',
                            style: TextStyle(
                                color: primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 8),
              Text(
                str('bpm_tip'),
                style: const TextStyle(
                    color: Color(0xFF555555), fontSize: 12, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  await context.read<UserProvider>().logSession();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(str('session_saved')),
                        backgroundColor: primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.go('/home');
                  }
                },
                child: Text(str('bpm_start')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
