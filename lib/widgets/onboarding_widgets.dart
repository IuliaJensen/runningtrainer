import 'package:flutter/material.dart';

class SelectCard extends StatelessWidget {
  final String icon;
  final String label;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const SelectCard({
    super.key,
    required this.icon,
    required this.label,
    required this.desc,
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? primary.withOpacity(0.12) : surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? primary : const Color(0xFF2A2A2A),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? primary : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: primary, size: 22)
            else
              const Icon(Icons.circle_outlined, color: Color(0xFF444444), size: 22),
          ],
        ),
      ),
    );
  }
}

class OnboardingProgress extends StatelessWidget {
  final int step;
  final int total;

  const OnboardingProgress({super.key, required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                color: i < step ? primary : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
