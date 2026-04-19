import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';

class _Interval {
  final bool isRun;
  final int seconds;
  const _Interval(this.isRun, this.seconds);
}

List<_Interval> _buildPlan(RunningLevel level) {
  switch (level) {
    case RunningLevel.beginner:
      return List.generate(
          6,
          (i) => i.isEven
              ? const _Interval(true, 90)
              : const _Interval(false, 120));
    case RunningLevel.intermediate:
      return List.generate(
          8,
          (i) => i.isEven
              ? const _Interval(true, 180)
              : const _Interval(false, 60));
    case RunningLevel.experienced:
      return List.generate(
          10,
          (i) => i.isEven
              ? const _Interval(true, 240)
              : const _Interval(false, 60));
  }
}

class MinutesTrainingScreen extends StatefulWidget {
  const MinutesTrainingScreen({super.key});

  @override
  State<MinutesTrainingScreen> createState() => _MinutesTrainingScreenState();
}

class _MinutesTrainingScreenState extends State<MinutesTrainingScreen> {
  late List<_Interval> _plan;
  int _intervalIndex = 0;
  int _remaining = 0;
  bool _running = false;
  bool _done = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _plan = _buildPlan(
        context.read<UserProvider>().profile.level);
    _remaining = _plan[0].seconds;
  }

  void _start() {
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 1) {
        setState(() => _remaining--);
      } else {
        _nextInterval();
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _nextInterval() {
    if (_intervalIndex < _plan.length - 1) {
      setState(() {
        _intervalIndex++;
        _remaining = _plan[_intervalIndex].seconds;
      });
    } else {
      _timer?.cancel();
      setState(() {
        _done = true;
        _running = false;
      });
      context.read<UserProvider>().logSession();
    }
  }

  void _stop() {
    _timer?.cancel();
    context.pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).colorScheme.surface;

    if (_done) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🎉', style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 24),
                  Text(str('minutes_complete'),
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: Text(provider.profile.locale == AppLocale.danish
                        ? 'Tilbage til hjem'
                        : 'Back to home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final current = _plan[_intervalIndex];
    final isRun = current.isRun;
    final accentColor = isRun ? primary : secondary;
    final roundNum = (_intervalIndex ~/ 2) + 1;
    final totalRounds = _plan.length ~/ 2;

    final progress = 1.0 - (_remaining / current.seconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(str('minutes_title')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _stop,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Round indicator
              Text(
                '${str('minutes_round')} $roundNum ${str('minutes_of')} $totalRounds',
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),

              // Big timer circle
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFF222222),
                        valueColor: AlwaysStoppedAnimation(accentColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isRun ? str('minutes_run') : str('minutes_rest'),
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _fmt(_remaining),
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_running && !_done)
                    _RoundButton(
                      icon: Icons.play_arrow,
                      label: _intervalIndex == 0 && _remaining == _plan[0].seconds
                          ? str('minutes_start')
                          : str('minutes_resume'),
                      color: primary,
                      onTap: _start,
                    ),
                  if (_running)
                    _RoundButton(
                      icon: Icons.pause,
                      label: str('minutes_pause'),
                      color: const Color(0xFF444444),
                      onTap: _pause,
                    ),
                  const SizedBox(width: 24),
                  _RoundButton(
                    icon: Icons.skip_next,
                    label: provider.profile.locale == AppLocale.danish
                        ? 'Skip'
                        : 'Skip',
                    color: const Color(0xFF333333),
                    onTap: _nextInterval,
                  ),
                ],
              ),

              const Spacer(),

              // Plan overview
              Text(
                str('minutes_plan'),
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _plan.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, i) {
                    final done = i < _intervalIndex;
                    final active = i == _intervalIndex;
                    final p = _plan[i];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      decoration: BoxDecoration(
                        color: done
                            ? const Color(0xFF2A2A2A)
                            : active
                                ? (p.isRun ? primary : secondary)
                                    .withOpacity(0.3)
                                : surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: active
                              ? (p.isRun ? primary : secondary)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          p.isRun ? '🏃' : '😮‍💨',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF888888), fontSize: 12)),
        ],
      ),
    );
  }
}
