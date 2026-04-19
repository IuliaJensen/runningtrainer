import '../models/user_profile.dart';

class CoachMessage {
  final String text;
  final bool isCoach;
  final DateTime time;

  CoachMessage({required this.text, required this.isCoach, DateTime? time})
      : time = time ?? DateTime.now();
}

class CoachService {
  static String greeting(RunningLevel level, String locale) {
    final da = {
      RunningLevel.beginner:
          'Hej! Godt at se dig. Som nybegynder er det vigtigste at komme i gang – og det har du allerede gjort. Hvad kan jeg hjælpe dig med?',
      RunningLevel.intermediate:
          'Hej! Du er godt i gang med din løbetræning. Lad os se om vi kan tage det et skridt videre. Hvad vil du vide?',
      RunningLevel.experienced:
          'Hej! Med din erfaring kan vi sætte ambitiøse mål. Hvad vil du optimere i dag?',
    };
    final en = {
      RunningLevel.beginner:
          "Hi! Great to see you. As a beginner, the most important thing is getting started — and you already have. How can I help?",
      RunningLevel.intermediate:
          "Hi! You're making great progress with your running. Let's take it to the next level. What would you like to know?",
      RunningLevel.experienced:
          "Hi! With your experience we can set ambitious goals. What would you like to optimise today?",
    };
    return (locale == 'da' ? da : en)[level]!;
  }

  static String respond(String input, RunningLevel level, String locale) {
    final lower = input.toLowerCase();
    final isDa = locale == 'da';

    if (_matches(lower, ['vejrtrækning', 'trække vejret', 'breathing', 'breathe'])) {
      return isDa
          ? 'Prøv 2-2 vejrtrækning: træk vejret ind over 2 skridt, ånd ud over 2 skridt. Mange løbere synes 3-2 (ind over 3, ud over 2) virker endnu bedre – det reducerer risikoen for sting i siden.'
          : 'Try 2-2 breathing: inhale for 2 steps, exhale for 2 steps. Many runners find 3-2 (in for 3, out for 2) works even better — it reduces the risk of side stitches.';
    }

    if (_matches(lower, ['opvarmning', 'warm', 'opvarme', 'før løb', 'before run'])) {
      return isDa
          ? 'Start altid med 5–10 minutters let gang eller jogging. Tilføj dynamiske strækøvelser: høje knæ, hælspark og hofterotationer. Statisk strækning gøres bedst EFTER løbeturen, ikke før.'
          : 'Always start with 5–10 minutes of light walking or jogging. Add dynamic stretches: high knees, heel kicks and hip rotations. Static stretching is best done AFTER the run, not before.';
    }

    if (_matches(lower, ['smerter', 'ondt', 'smerte', 'pain', 'hurt', 'ache', 'skade', 'injury'])) {
      return isDa
          ? 'Lyt altid til din krop. Skarp smerte under en løbetur = stop med det samme. Mild ømhed dagen efter er normalt. Knæsmerter, skinneben eller hælsmerter bør undersøges af en fysioterapeut hvis de varer mere end en uge.'
          : 'Always listen to your body. Sharp pain during a run = stop immediately. Mild soreness the day after is normal. Knee pain, shin splints or heel pain should be seen by a physiotherapist if they last more than a week.';
    }

    if (_matches(lower, ['motivation', 'motiveret', 'motivated', 'gider ikke', 'can\'t be bothered', 'træt', 'tired'])) {
      return isDa
          ? 'Husk: du behøver ikke føle dig motiveret for at løbe. Motivation kommer EFTER du er kommet i gang. Prøv "2-minutters-reglen" – løb bare 2 minutter. Vil du stoppe bagefter, så gør det. Oftest vil du fortsætte 😊'
          : "Remember: you don't need to feel motivated to run. Motivation comes AFTER you start. Try the '2-minute rule' — just run for 2 minutes. If you still want to stop, do it. Most of the time you'll keep going 😊";
    }

    if (_matches(lower, ['tempo', 'pace', 'hurtigt', 'langsomt', 'fast', 'slow', 'fart'])) {
      if (level == RunningLevel.beginner) {
        return isDa
            ? 'Som nybegynder: løb i et tempo hvor du KAN snakke i fulde sætninger. Det kalder vi "samtaletempo". Det føles for langsomt – men det er præcis det rigtige til at bygge dit aerobe grundlag.'
            : 'As a beginner: run at a pace where you CAN speak in full sentences. We call this "conversation pace". It feels too slow — but it is exactly right for building your aerobic base.';
      }
      return isDa
          ? 'En god tommelfingerregel: 80% af din løbetræning skal foregå i et let, behageligt tempo (zone 2). Kun 20% bør være hårde intervaller. De fleste løbere fejler ved at løbe for hårdt for ofte.'
          : 'A good rule of thumb: 80% of your running should be at an easy, comfortable pace (zone 2). Only 20% should be hard intervals. Most runners make the mistake of running too hard too often.';
    }

    if (_matches(lower, ['restitution', 'hvile', 'rest', 'recovery', 'søvn', 'sleep'])) {
      return isDa
          ? 'Restitution er lige så vigtigt som selve træningen. Kroppen bliver stærkere i hvilefasen. Prøv: 1 hviledag efter 2 løbedage. Sørg for 7–9 timers søvn. Lettere aktivitet som gang er fint på hviledage.'
          : 'Recovery is just as important as the training itself. Your body gets stronger during the rest phase. Try: 1 rest day for every 2 running days. Aim for 7–9 hours of sleep. Light activity like walking is fine on rest days.';
    }

    if (_matches(lower, ['sko', 'shoes', 'løbesko', 'running shoes', 'støvler'])) {
      return isDa
          ? 'Gode løbesko er din vigtigste investering. Få lavet en løbeanalyse i en løbebutik – de ser på dit fodtryk og anbefaler det rette. Skift sko ca. hvert 600–800 km (ikke efter tid, men efter distance).'
          : 'Good running shoes are your most important investment. Get a gait analysis at a running shop — they look at your footstrike and recommend the right shoe. Replace shoes roughly every 600–800 km (not by time, but by distance).';
    }

    if (_matches(lower, ['kost', 'mad', 'spise', 'food', 'eat', 'nutrition', 'ernæring'])) {
      return isDa
          ? 'Spis et let måltid 2–3 timer før løb (kulhydrater + lidt protein). Undgå fedt og fibre lige inden. Inden 30 minutters løb behøver du ikke spise noget. Drik ca. 500 ml vand 2 timer inden.'
          : 'Eat a light meal 2–3 hours before running (carbs + a little protein). Avoid fat and fibre right before. For runs under 30 minutes you do not need to eat beforehand. Drink about 500 ml of water 2 hours before.';
    }

    if (_matches(lower, ['interval', 'intervaller', 'intervals', 'hiit'])) {
      return isDa
          ? 'Intervaltræning er super effektivt for kontormennesket med travl hverdag. Start med 1:2-forhold (1 min løb : 2 min hvile) og byg gradvist op. Vores Minutter-model er perfekt til dette!'
          : 'Interval training is super effective for office workers with busy days. Start with a 1:2 ratio (1 min run : 2 min rest) and build gradually. Our Minutes model is perfect for this!';
    }

    if (_matches(lower, ['garmin', 'data', 'statistik', 'statistics', 'analyse', 'analyse'])) {
      return isDa
          ? 'Du kan uploade et screenshot fra din Garmin Connect-app under Progress-fanen. Jeg kan hjælpe dig med at forstå dine data – puls, tempo, distance og kadence.'
          : 'You can upload a screenshot from your Garmin Connect app under the Progress tab. I can help you understand your data — heart rate, pace, distance and cadence.';
    }

    // Default response
    if (isDa) {
      final responses = [
        'Det er et godt spørgsmål! Som kontorløber er det vigtigste at skabe gode vaner. Prøv at løbe på samme tidspunkt hver dag – morgen, frokost eller efter arbejde.',
        'Husk: en kort løbetur er bedre end ingen løbetur. Selv 20 minutter 3 gange om ugen giver mærkbar fremgang på 4–6 uger.',
        'Mit bedste råd: vær tålmodig med dig selv. Fremgang i løb sker ikke overnight, men kommer sikkert og stødt. Stol på processen!',
      ];
      return responses[input.length % responses.length];
    } else {
      final responses = [
        "Great question! As an office runner, the most important thing is building good habits. Try running at the same time every day — morning, lunch or after work.",
        'Remember: a short run is better than no run. Even 20 minutes 3 times a week shows noticeable improvement after 4–6 weeks.',
        'My best advice: be patient with yourself. Progress in running does not happen overnight, but it comes steadily. Trust the process!',
      ];
      return responses[input.length % responses.length];
    }
  }

  static bool _matches(String input, List<String> keywords) {
    return keywords.any((k) => input.contains(k));
  }
}
