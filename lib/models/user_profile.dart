import 'dart:convert';

enum RunningLevel { beginner, intermediate, experienced }
enum RunningEnvironment { treadmill, trail, road }
enum RunningGoal { fitness, k5, k10, halfMarathon, marathon }
enum AppThemeVariant { garmin, nike, sport }
enum AppLocale { danish, english }

extension AppLocaleExt on AppLocale {
  String get code => this == AppLocale.danish ? 'da' : 'en';
}

class UserProfile {
  final RunningLevel level;
  final RunningEnvironment environment;
  final RunningGoal goal;
  final AppThemeVariant themeVariant;
  final AppLocale locale;
  final bool onboardingComplete;
  final int currentStreak;
  final List<String> completedSessions;
  final List<String> earnedBadges;

  const UserProfile({
    this.level = RunningLevel.beginner,
    this.environment = RunningEnvironment.road,
    this.goal = RunningGoal.k5,
    this.themeVariant = AppThemeVariant.garmin,
    this.locale = AppLocale.danish,
    this.onboardingComplete = false,
    this.currentStreak = 0,
    this.completedSessions = const [],
    this.earnedBadges = const [],
  });

  UserProfile copyWith({
    RunningLevel? level,
    RunningEnvironment? environment,
    RunningGoal? goal,
    AppThemeVariant? themeVariant,
    AppLocale? locale,
    bool? onboardingComplete,
    int? currentStreak,
    List<String>? completedSessions,
    List<String>? earnedBadges,
  }) {
    return UserProfile(
      level: level ?? this.level,
      environment: environment ?? this.environment,
      goal: goal ?? this.goal,
      themeVariant: themeVariant ?? this.themeVariant,
      locale: locale ?? this.locale,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      currentStreak: currentStreak ?? this.currentStreak,
      completedSessions: completedSessions ?? this.completedSessions,
      earnedBadges: earnedBadges ?? this.earnedBadges,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level.index,
        'environment': environment.index,
        'goal': goal.index,
        'themeVariant': themeVariant.index,
        'locale': locale.index,
        'onboardingComplete': onboardingComplete,
        'currentStreak': currentStreak,
        'completedSessions': completedSessions,
        'earnedBadges': earnedBadges,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        level: RunningLevel.values[json['level'] as int? ?? 0],
        environment: RunningEnvironment.values[json['environment'] as int? ?? 2],
        goal: RunningGoal.values[json['goal'] as int? ?? 1],
        themeVariant: AppThemeVariant.values[json['themeVariant'] as int? ?? 0],
        locale: AppLocale.values[json['locale'] as int? ?? 0],
        onboardingComplete: json['onboardingComplete'] as bool? ?? false,
        currentStreak: json['currentStreak'] as int? ?? 0,
        completedSessions: List<String>.from(json['completedSessions'] as List? ?? []),
        earnedBadges: List<String>.from(json['earnedBadges'] as List? ?? []),
      );

  factory UserProfile.fromJsonString(String jsonStr) =>
      UserProfile.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}
