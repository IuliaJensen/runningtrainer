import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/app_strings.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _profile = const UserProfile();

  UserProfile get profile => _profile;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('user_profile');
    if (json != null) {
      try {
        _profile = UserProfile.fromJsonString(json);
      } catch (_) {}
    }
  }

  String str(String key) => AppStrings.get(key, locale: _profile.locale.code);

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', _profile.toJsonString());
  }

  Future<void> update(UserProfile profile) async {
    _profile = profile;
    await _save();
    notifyListeners();
  }

  Future<void> setLocale(AppLocale locale) =>
      update(_profile.copyWith(locale: locale));

  Future<void> setLevel(RunningLevel level) =>
      update(_profile.copyWith(level: level));

  Future<void> setEnvironment(RunningEnvironment env) =>
      update(_profile.copyWith(environment: env));

  Future<void> setGoal(RunningGoal goal) =>
      update(_profile.copyWith(goal: goal));

  Future<void> setTheme(AppThemeVariant variant) =>
      update(_profile.copyWith(themeVariant: variant));

  Future<void> completeOnboarding() =>
      update(_profile.copyWith(onboardingComplete: true));

  Future<void> logSession() async {
    final today = _dateKey(DateTime.now());
    final sessions = List<String>.from(_profile.completedSessions);
    if (!sessions.contains(today)) sessions.add(today);

    final streak = _calcStreak(sessions);
    final badges = _calcBadges(sessions, streak, _profile.earnedBadges);

    await update(_profile.copyWith(
      completedSessions: sessions,
      currentStreak: streak,
      earnedBadges: badges,
    ));
  }

  Future<void> resetProgress() async {
    await update(_profile.copyWith(
      completedSessions: [],
      currentStreak: 0,
      earnedBadges: [],
    ));
  }

  int get sessionsThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _profile.completedSessions.where((s) {
      final d = DateTime.parse(s);
      return !d.isBefore(weekStart);
    }).length;
  }

  static int _calcStreak(List<String> sessions) {
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final key = _dateKey(now.subtract(Duration(days: i)));
      if (sessions.contains(key)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static List<String> _calcBadges(
      List<String> sessions, int streak, List<String> current) {
    final badges = List<String>.from(current);
    void add(String b) {
      if (!badges.contains(b)) badges.add(b);
    }

    if (sessions.isNotEmpty) add('first_run');
    if (sessions.length >= 5) add('five_runs');
    if (sessions.length >= 10) add('ten_runs');
    if (streak >= 3) add('streak_3');
    if (streak >= 7) add('streak_7');
    return badges;
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
