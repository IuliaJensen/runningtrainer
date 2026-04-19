# Løbecoachen

Din personlige løbecoach – bygget til kontormennesket der vil løbe.

## Kom i gang

### Forudsætninger
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.3.0
- Android Studio eller Xcode (til emulator/device)

### Installation

```bash
git clone https://github.com/IuliaJensen/runningtrainer.git
cd runningtrainer
flutter pub get
flutter run
```

## Funktioner

### Onboarding
- Sprogvalg (Dansk / English)
- Niveauvalg (Nybegynder / Øvet / Erfaren)
- Underlagsvalg (Løbebånd / Trail / Vej)
- Målsætning (5K / 10K / Halvmarathon / Marathon / Motion)

### Tre træningsmodeller
| Model | Beskrivelse |
|-------|-------------|
| ⏱️ **Minutter** | Interval-timer med tilpasset plan baseret på niveau |
| 🎵 **BPM** | Anbefalet musik-BPM + sangliste baseret på mål og niveau |
| 🏃 **Lygtepæle** | Tæl lygtepæle som naturlige interval-markører |

### Coach
Scriptede svar på de mest almindelige løbespørgsmål:
vejrtrækning, opvarmning, smerter, motivation, tempo, restitution, sko og kost.

### Fremskridt
- Daglig streak-tracker
- Ugentlig aktivitetsoversigt
- Badges / achievements
- Garmin Connect screenshot upload

### Indstillinger
- Skift sprog til enhver tid
- 3 visuelle temaer (Garmin, Nike-stil, Sport)
- Rediger niveau / underlag / mål
- Nulstil fremskridt

## Arkitektur

```
lib/
├── main.dart               # Entry point
├── app.dart                # Router + MaterialApp
├── theme/
│   └── app_theme.dart      # 3 dark themes
├── models/
│   ├── user_profile.dart   # Enums + UserProfile
│   └── bpm_data.dart       # SongExample model
├── providers/
│   └── user_provider.dart  # State + SharedPreferences
├── services/
│   ├── app_strings.dart    # DA/EN localization
│   ├── bpm_service.dart    # BPM logic + song library
│   └── coach_service.dart  # Scripted coach responses
└── screens/
    ├── onboarding/         # 4 onboarding screens
    ├── home/               # Dashboard
    ├── training/           # 3 training models
    ├── coach/              # Chat interface
    ├── progress/           # Stats + badges + Garmin
    └── settings/           # Profile + theme
```

## Næste trin (roadmap)

- [ ] Garmin Connect API integration
- [ ] Push-notifikationer til daglige remindere
- [ ] Cloud sync (Firebase / Supabase)
- [ ] Race-planlægger med ugeprogram
- [ ] Musik-app integration (Spotify BPM-søgning)
- [ ] Freemium paywall (BPM + Garmin = premium)
