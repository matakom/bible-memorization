import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/data/repositories/exercise_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/saved_verses_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/repositories/friendships_repository.dart';
import '../../services/srs/srs_types.dart';
import '../../services/srs/algorithms/sm2_algorithm.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final srsServiceProvider = Provider<SrsAlgorithm>((ref) {
  return Sm2Algorithm();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn.instance,
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return UserRepository(db.usersDao);
});

final savedVersesRepositoryProvider = Provider<SavedVersesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final srsService = ref.watch(srsServiceProvider);
  return SavedVersesRepository(db.savedVersesDao, srsService);
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return StatsRepository(db.exercisesDao, db.savedVersesDao);
});

final friendshipRepositoryProvider = Provider<FriendshipRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FriendshipRepository(db.friendshipsDao);
});

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ExerciseRepository(db.exercisesDao);
});