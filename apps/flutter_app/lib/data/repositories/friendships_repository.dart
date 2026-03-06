import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/friendship.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:uuid/uuid.dart';
import '../../providers/core/dio_provider.dart';
import '../../utils/debugger.dart';

class FriendshipsException implements Exception {
  final String message;
  FriendshipsException(this.message);
  @override
  String toString() => message;
}

class FriendshipsRepository {
  final Dio _dio;
  final db.AppDatabase _db;
  final Ref _ref;

  FriendshipsRepository(this._dio, this._db, this._ref);

  Future<List<Friendship>> getFriendships() async {
    try {
      final rows =
          await (_db.select(_db.friendships)
                ..where((t) => t.deletedAt.isNull()))
              .get();
      return rows.map((row) => Friendship.fromEntity(row)).toList();
    } catch (e) {
      throw FriendshipsException('Failed to load local friendships: $e');
    }
  }

  Future<void> sendFriendshipRequest(String friendCode) async {
    try {
      final localUser = await (_db.select(_db.users)).getSingleOrNull();
      if (localUser == null) {
        throw FriendshipsException("You must be logged in to add friends.");
      }
      final myId = localUser.id;

      final response = await _dio.get(
        '/user/lookup',
        queryParameters: {'friendCode': friendCode},
      );
      final friendData = response.data;
      final friendId = friendData['id'];

      if (friendId == myId) {
        throw FriendshipsException("You cannot add yourself as a friend.");
      }

      final existingFriendship = await (_db.select(
        _db.friendships,
      )..where((t) => t.friendId.equals(friendId))).getSingleOrNull();

      if (existingFriendship != null) {
        if (existingFriendship.status == 'pending') {
          throw FriendshipsException(
            "You already sent a request to this person.",
          );
        } else if (existingFriendship.status == 'accepted') {
          throw FriendshipsException(
            "You are already friends with this person.",
          );
        } else {
          throw FriendshipsException(
            "Friendship status is already ${existingFriendship.status}.",
          );
        }
      }

      await _db
          .into(_db.friendships)
          .insert(
            db.FriendshipsCompanion.insert(
              id: const Uuid().v4(),
              userId: myId,
              friendId: friendId,
              friendFirstName: friendData['firstName'],
              friendLastName: friendData['lastName'],
              status: 'pending',
              needsSync: const Value(true),
              updatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );


      final syncService = await _ref.read(syncServiceProvider.future);
      syncService.runSync();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw FriendshipsException("User with this code not found.");
      }
      throw FriendshipsException("Connection error.");
    } catch (e) {
      if (e is FriendshipsException) rethrow;

      Debugger.log("LOCAL ERROR: $e");
      throw FriendshipsException("Failed to save request locally.");
    }
  }

  Future<void> acceptFriendship(String friendshipId) async {
    await (_db.update(
      _db.friendships,
    )..where((t) => t.id.equals(friendshipId))).write(
      db.FriendshipsCompanion(
        status: const Value('accepted'),
        updatedAt: Value(DateTime.now()),
        needsSync: const Value(true),
      ),
    );
    _triggerSync();
  }

  Future<void> deleteFriendship(String friendshipId) async {
    await (_db.update(
      _db.friendships,
    )..where((t) => t.id.equals(friendshipId))).write(
      db.FriendshipsCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        needsSync: const Value(true),
      ),
    );
    _triggerSync();
  }

  void _triggerSync() {
    _ref.read(syncServiceProvider.future).then((s) => s.runSync());
  }
}

final friendshipsRepositoryProvider = FutureProvider<FriendshipsRepository>((ref) async {
  // THE FIX: Watch the centralized dioProvider!
  final dio = await ref.watch(dioProvider.future);
  
  final database = ref.watch(db.databaseProvider);
  return FriendshipsRepository(dio, database, ref);
});