import '../local/enums.dart';

class ExerciseResult {
  final String id;
  final String savedVerseId;
  final GameType gameType;
  final double score;
  final int durationMs;
  final DateTime performedAt;

  ExerciseResult({
    required this.id,
    required this.savedVerseId,
    required this.gameType,
    required this.score,
    required this.durationMs,
    required this.performedAt,
  });

}