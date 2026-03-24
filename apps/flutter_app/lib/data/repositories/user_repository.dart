import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/utils/network_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/core/dio_provider.dart';

/// Manages user profile data and account lifecycle operations.
class UserRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final db.AppDatabase _db;
  static const String _kCachedUserKey = 'cached_user_profile';

  UserRepository(this._dio, this._prefs, this._db);

  Future<AppUser> getUserData({String? manualToken}) async {
    try {
      final options = manualToken != null
          ? Options(headers: {'Authorization': 'Bearer $manualToken'})
          : null;
      final response = await _dio.post('/user/login', options: options);
      final user = AppUser.fromJson(response.data as Map<String, dynamic>);

      await _prefs.setString(_kCachedUserKey, json.encode(response.data));
      await _db
          .into(_db.users)
          .insert(
            db.UsersCompanion.insert(
              id: user.id,
              email: user.email,
              firstName: user.firstName,
              lastName: user.lastName,
              language: Value(user.language),
              friendCode: Value(user.friendCode),
              needsSync: const Value(false),
              updatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );

      return user;
    } on DioException catch (e) {
      final isOffline =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException;
      final isServerDown =
          e.response?.statusCode != null && e.response!.statusCode! >= 500;

      final localUser = await getLocalUser();
      if (localUser != null) return localUser;

      if (isServerDown) throw ServerDownException();
      if (isOffline) throw OfflineException();
      throw Exception("Connection required for initial login.");
    }
  }

  Stream<AppUser?> watchLocalUser() {
    return (_db.select(_db.users)..limit(1)).watchSingleOrNull().map(
      (row) => row != null ? AppUser.fromDb(row) : null,
    );
  }

  Future<AppUser?> getLocalUser() async {
    final dbUser = await (_db.select(_db.users)..limit(1)).getSingleOrNull();
    if (dbUser != null) {
      return AppUser(
        id: dbUser.id,
        email: dbUser.email,
        firstName: dbUser.firstName,
        lastName: dbUser.lastName,
        language: dbUser.language,
        friendCode: dbUser.friendCode ?? '',
        registeredAt: dbUser.updatedAt,
      );
    }

    final cachedString = _prefs.getString(_kCachedUserKey);
    if (cachedString != null) {
      try {
        return AppUser.fromJson(
          json.decode(cachedString) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    return null;
  }

  Future<void> deleteAccountLocally() async {
    try {
      await _dio.delete('/user/me');

      await _db.transaction(() async {
        await _db.delete(_db.exercises).go();
        await _db.delete(_db.savedVerses).go();
        await _db.delete(_db.friendships).go();
        await _db.delete(_db.users).go();
      });

      await _prefs.clear();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          "Server unreachable. Please check your internet to delete your account.",
        );
      }
      rethrow;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }
}

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  final prefs = await SharedPreferences.getInstance();
  final database = ref.watch(db.databaseProvider);
  return UserRepository(dio, prefs, database);
});
