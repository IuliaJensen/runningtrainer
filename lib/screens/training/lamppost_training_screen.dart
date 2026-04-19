import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';

class LamppostTrainingScreen extends StatefulWidget {
  const LamppostTrainingScreen({super.key});

  @override
  State<LamppostTrainingScreen> createState() => _LamppostTrainingScreenState();
}

class _LamppostTrainingScreenState extends State<LamppostTrainingScreen>
    with SingleTickerProviderStateMixin {
  int _lampposts = 0;
  bool _isRunning = true;
  int _rounds = 0;
  bool _started = false;
  late final AnimationController _anim;

  int get _targetLamppostsPerRound {
    switch (context.read<UserProvider>().profile.level) {
      case RunningLevel.beginner:
        return 2;
      case RunningLevel.intermediate:
        return 3;
      case RunningLevel.experienced:
        return 4;
    }
  }

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _tap() {
    HapticFeedback.lightImpact();
    _anim.forward().then((_) => _anim.reverse());

    setState(() {
      if (!_started) _started = true;
      _lampposts++;

      if (_lampposts % _targetLamppostsPerRound == 0) {
        _isRunning = !_isRunning;
        if (_isRunning) _rounds++;
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _stop() async {
    if (_lampposts > 0) {
      await context.read<UserProvider>().logSession();
    }
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final str = provider.str;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).colorScheme.surface;
    final accentColor = _isRunning ? primary : secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(str('lamppost_title')),
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
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoBox(
                    value: _lampposts.toString(),
                    label: str('lamppost_total'),
                    color: primary,
                  ),
                  _InfoBox(
                    value: _rounds.toString(),
                    label: str('lamppost_rounds'),
                    color: const Color(0xFF888888),
                  ),
                ],
              ),

              const Spacer(),

              // Current state label
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _started
                      ? (_isRunning ? str('lamppost_run') : str('lamppost_rest'))
                      : str('lamppost_tap'),
                  key: ValueKey(_isRunning.toString() + _started.toString()),
                  style: TextStyle(
                    color: _started ? accentColor : const Color(0xFF888888),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Big tap button
              GestureDetector(
                onTap: _tap,
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 0.93).animate(
                    CurvedAnimation(parent: _anim, curve: Curves.easeOut),
                  ),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.15),
                      border: Border.all(color: accentColor, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRunning ? '🏃' : '😮‍💨',
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _lampposts.toString(),
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Progress dots (next interval)
              if (_started) ...[
                Text(
                  provider.profile.locale == AppLocale.danish
                      ? 'Næste skift om ${_targetLamppostsPerRound - (_lampposts % _targetLamppostsPerRound)} lygtepæl(e)'
                      : 'Next change in ${_targetLamppostsPerRound - (_lampposts % _targetLamppostsPerRound)} lamp post(s)',
                  style: const TextStyle(
                      color: Color(0xFF666666), fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_targetLamppostsPerRound, (i) {
                    final filled = i < (_lampposts % _targetLamppostsPerRound);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? accentColor : const Color(0xFF2A2A2A),
                        ),
                      ),
                    );
                  }),
                ),
              ],

              const SizedBox(height: 32),

              TextButton(
                onPressed: _stop,
                child: Text(
                  str('lamppost_stop'),
                  style: const TextStyle(color: Color(0xFF666666)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _InfoBox({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              color: color, fontSize: 36, fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
        ),
      ],
    );
  }
}
