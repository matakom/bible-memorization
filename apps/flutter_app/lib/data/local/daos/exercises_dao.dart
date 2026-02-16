import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/exercises.dart';

part 'exercises_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExercisesDao extends DatabaseAccessor<AppDatabase> with _$ExercisesDaoMixin {
  ExercisesDao(super.db);

  /// Save a game result.
  Future<int> insertExercise(ExercisesCompanion entry) {
    return into(exercises).insert(entry);
  }

  /// Get last 30 days of exercises
  Future<List<Exercise>> getRecentHistory() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return (select(exercises)
      ..where((t) => t.performedAt.isBiggerOrEqualValue(thirtyDaysAgo))
      ..orderBy([(t) => OrderingTerm(expression: t.performedAt, mode: OrderingMode.desc)]))
      .get();
  }
  
  Stream<List<Exercise>> watchRecentHistory() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return (select(exercises)
      ..where((t) => t.performedAt.isBiggerOrEqualValue(thirtyDaysAgo))
      ..orderBy([(t) => OrderingTerm(expression: t.performedAt, mode: OrderingMode.desc)]))
      .watch();
  }
}