import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../local/app_database.dart';
import '../local/daos/exercises_dao.dart';
import '../local/enums.dart';
import '../models/exercise_result.dart';

class ExerciseRepository {
  final ExercisesDao _dao;

  ExerciseRepository(this._dao);

  Future<void> saveResult({
    required String savedVerseId,
    required GameType gameType,
    required double score,
    required int durationMs,
  }) async {
    final entry = ExercisesCompanion(
      id: Value(const Uuid().v4()),
      savedVerseId: Value(savedVerseId),
      gameType: Value(gameType),
      rawScore: Value(score),
      durationMs: Value(durationMs),
      performedAt: Value(DateTime.now()), 
      needsSync: const Value(true), 
    );

    await _dao.insertExercise(entry);
  }

  Future<List<ExerciseResult>> getRecentHistory() async {
    final rows = await _dao.getRecentHistory();
    
    return rows.map((row) => ExerciseResult(
      id: row.id,
      savedVerseId: row.savedVerseId,
      gameType: row.gameType,
      score: row.rawScore,
      durationMs: row.durationMs,
      performedAt: row.performedAt,
    )).toList();
  }
}