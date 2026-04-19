import '../models/user_profile.dart';
import '../models/bpm_data.dart';

class BpmService {
  static int recommendBpm(RunningLevel level, RunningGoal goal) {
    const table = {
      // Beginner
      '0_0': 150, // beginner + fitness
      '0_1': 155, // beginner + 5K
      '0_2': 158, // beginner + 10K
      '0_3': 160, // beginner + half
      '0_4': 158, // beginner + marathon
      // Intermediate
      '1_0': 158,
      '1_1': 163,
      '1_2': 167,
      '1_3': 168,
      '1_4': 165,
      // Experienced
      '2_0': 165,
      '2_1': 172,
      '2_2': 175,
      '2_3': 174,
      '2_4': 172,
    };
    return table['${level.index}_${goal.index}'] ?? 165;
  }

  static String getTargetPace(RunningLevel level, RunningGoal goal) {
    const table = {
      '0_1': '7:00–8:30 min/km',
      '0_2': '7:30–9:00 min/km',
      '0_3': '8:00–9:30 min/km',
      '0_4': '8:30–10:00 min/km',
      '0_0': '7:00–9:00 min/km',
      '1_1': '5:30–6:30 min/km',
      '1_2': '5:45–6:45 min/km',
      '1_3': '6:00–7:00 min/km',
      '1_4': '6:30–7:30 min/km',
      '1_0': '6:00–7:00 min/km',
      '2_1': '4:30–5:20 min/km',
      '2_2': '4:45–5:30 min/km',
      '2_3': '5:00–5:45 min/km',
      '2_4': '5:15–6:00 min/km',
      '2_0': '5:00–6:00 min/km',
    };
    return table['${level.index}_${goal.index}'] ?? '6:00–7:00 min/km';
  }

  static List<SongExample> getSongsNear(int targetBpm) {
    return _songs
        .where((s) => (s.bpm - targetBpm).abs() <= 6)
        .toList()
      ..sort((a, b) => (a.bpm - targetBpm).abs().compareTo((b.bpm - targetBpm).abs()));
  }

  static const List<SongExample> _songs = [
    SongExample(title: "Don't Stop Me Now", artist: 'Queen', bpm: 156),
    SongExample(title: 'Shake It Off', artist: 'Taylor Swift', bpm: 160),
    SongExample(title: 'Happy', artist: 'Pharrell Williams', bpm: 160),
    SongExample(title: 'Sicko Mode', artist: 'Travis Scott', bpm: 155),
    SongExample(title: 'Mr. Brightside', artist: 'The Killers', bpm: 148),
    SongExample(title: 'Jump Around', artist: 'House of Pain', bpm: 165),
    SongExample(title: 'Good 4 U', artist: 'Olivia Rodrigo', bpm: 166),
    SongExample(title: 'Hall of Fame', artist: 'The Script ft. will.i.am', bpm: 167),
    SongExample(title: 'Blinding Lights', artist: 'The Weeknd', bpm: 171),
    SongExample(title: 'Lose Yourself', artist: 'Eminem', bpm: 171),
    SongExample(title: 'Til I Collapse', artist: 'Eminem', bpm: 171),
    SongExample(title: 'Without Me', artist: 'Eminem', bpm: 170),
    SongExample(title: 'Born to Run', artist: 'Bruce Springsteen', bpm: 175),
    SongExample(title: 'Sabotage', artist: 'Beastie Boys', bpm: 170),
    SongExample(title: 'Run Boy Run', artist: 'Woodkid', bpm: 152),
    SongExample(title: 'Run', artist: 'Foo Fighters', bpm: 170),
    SongExample(title: 'Therefore I Am', artist: 'Billie Eilish', bpm: 149),
    SongExample(title: 'Bad Guy', artist: 'Billie Eilish', bpm: 135),
    SongExample(title: 'Pump It', artist: 'Black Eyed Peas', bpm: 153),
    SongExample(title: 'Power', artist: 'Kanye West', bpm: 140),
    SongExample(title: 'We Found Love', artist: 'Rihanna ft. Calvin Harris', bpm: 128),
    SongExample(title: "Don't You Worry Child", artist: 'Swedish House Mafia', bpm: 128),
    SongExample(title: 'Levels', artist: 'Avicii', bpm: 128),
    SongExample(title: 'Stronger', artist: 'Daft Punk', bpm: 128),
    SongExample(title: 'Wake Me Up', artist: 'Avicii', bpm: 124),
    SongExample(title: 'Gold Digger', artist: 'Kanye West ft. Jamie Foxx', bpm: 128),
    SongExample(title: "Livin' on a Prayer", artist: 'Bon Jovi', bpm: 123),
    SongExample(title: 'Welcome to the Jungle', artist: "Guns N' Roses", bpm: 127),
    SongExample(title: 'Thunderstruck', artist: 'AC/DC', bpm: 134),
    SongExample(title: 'Eye of the Tiger', artist: 'Survivor', bpm: 109),
    SongExample(title: 'Uptown Funk', artist: 'Bruno Mars', bpm: 115),
    SongExample(title: "Can't Stop the Feeling!", artist: 'Justin Timberlake', bpm: 113),
    SongExample(title: 'Levitating', artist: 'Dua Lipa', bpm: 103),
    SongExample(title: 'Physical', artist: 'Dua Lipa', bpm: 96),
    SongExample(title: 'As It Was', artist: 'Harry Styles', bpm: 125),
    SongExample(title: 'Circles', artist: 'Post Malone', bpm: 92),
  ];
}
