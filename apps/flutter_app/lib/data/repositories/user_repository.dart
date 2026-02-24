import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final db.AppDatabase _db;
  
  static const String _kCachedUserKey = 'cached_user_profile';

  UserRepository(this._dio, this._prefs, this._db);

  Future<AppUser> getUserData({String? manualToken}) async {
    try {

      final options = manualToken != null ? Options(headers: {'Authorization': 'Bearer $manualToken'}) : null;

      // 1. Try Network
      final response = await _dio.get('/user', options: options);
      final user = AppUser.fromJson(response.data as Map<String, dynamic>);
      
      // 2. Save to Cache
      await _prefs.setString(_kCachedUserKey, json.encode(response.data));

      // 3. SAVE TO SQLITE
      await _db.into(_db.users).insert(
        db.UsersCompanion.insert(
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          language: Value(user.language), 
          needsSync: const Value(false),
          updatedAt: Value(DateTime.now()), 
        ),
        mode: InsertMode.insertOrReplace,
      );

      return user;
      
    } catch (e) {
      // 4. Offline Fallback
      // Try SharedPreferences first (Fastest)
      final cachedString = _prefs.getString(_kCachedUserKey);
      if (cachedString != null) {
        return AppUser.fromJson(json.decode(cachedString) as Map<String, dynamic>);
      }

      // 5. No Data Found
      throw Exception("Connection required for initial login.");
    }
  }
  Future<AppUser?> getLocalUser() async {
    final cachedString = _prefs.getString(_kCachedUserKey);
    if (cachedString != null) {
      return AppUser.fromJson(json.decode(cachedString) as Map<String, dynamic>);
    }
    return null;
  }
  Future<void> deleteAccountLocally() async {
    try {
      // TODO: Add backend API call here later 
      // await _dio.delete('/users/me');

      // 1. Wipe all local Drift tables in a transaction
      await _db.transaction(() async {
        await _db.delete(_db.exercises).go();
        await _db.delete(_db.savedVerses).go();
        await _db.delete(_db.friendships).go();
        await _db.delete(_db.users).go();
      });

      // 2. Clear all cached data (like the user profile and JWT token)
      await _prefs.clear();
      
    } catch (e) {
      throw Exception('Failed to delete local data: $e');
    }
  }
}

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  final prefs = await SharedPreferences.getInstance();
  final database = ref.watch(db.databaseProvider); 
  return UserRepository(dio, prefs, database);
});