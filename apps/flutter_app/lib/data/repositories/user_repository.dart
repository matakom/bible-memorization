import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/utils/debugger.dart';

class UserRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final db.AppDatabase _db;
  
  static const String _kCachedUserKey = 'cached_user_profile';

  UserRepository(this._dio, this._prefs, this._db);

  /// Fetches user data from the server, updates local caches, and saves to SQLite.
  /// Falls back to local storage if the network request fails.
  Future<AppUser> getUserData({String? manualToken}) async {
    try {
      final options = manualToken != null 
          ? Options(headers: {'Authorization': 'Bearer $manualToken'}) 
          : null;

      // 1. Attempt Network Fetch
      final response = await _dio.get('/user', options: options);
      final user = AppUser.fromJson(response.data as Map<String, dynamic>);
      
      // 2. Update SharedPreferences Cache (for legacy/quick access)
      await _prefs.setString(_kCachedUserKey, json.encode(response.data));

      // 3. Update SQLite (The Single Source of Truth)
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
      Debugger.log("UserRepository: Network fetch failed. $e");

      // 4. Offline Fallback: Check local sources
      final localUser = await getLocalUser();
      if (localUser != null) {
        return localUser;
      }

      // 5. Critical Fail (usually on very first login with no internet)
      throw Exception("Connection required for initial login.");
    }
  }

  /// Retrieves the user from SQLite or SharedPreferences without hitting the network.
  Future<AppUser?> getLocalUser() async {
    // Priority 1: SQLite (Most up-to-date)
    final dbUser = await (_db.select(_db.users)..limit(1)).getSingleOrNull();
    if (dbUser != null) {
      return AppUser(
        id: dbUser.id,
        email: dbUser.email,
        firstName: dbUser.firstName,
        lastName: dbUser.lastName,
        language: dbUser.language,
        friendCode: 'OFFLINE', // Mark as offline until next successful sync
        registeredAt: dbUser.updatedAt
      );
    }

    // Priority 2: SharedPreferences JSON string
    final cachedString = _prefs.getString(_kCachedUserKey);
    if (cachedString != null) {
      try {
        return AppUser.fromJson(json.decode(cachedString) as Map<String, dynamic>);
      } catch (e) {
        Debugger.log("UserRepository: Failed to parse cached JSON: $e");
      }
    }
    
    return null;
  }

  /// Triggers a remote account deletion and, if successful, wipes all local data.
  Future<void> deleteAccountLocally() async {
    try {
      // 1. Attempt Remote Deletion FIRST
      // This sends the DELETE request to your NestJS '/user/me' endpoint.
      // If the server returns an error or is unreachable, this will throw an exception,
      // and the local wipe will NOT happen (preserving user data).
      await _dio.delete('/user/me');
      
      Debugger.log("UserRepository: Remote account deletion successful.");

      // 2. Perform Local Wipe
      // Wrapped in a transaction to ensure database integrity.
      await _db.transaction(() async {
        await _db.delete(_db.exercises).go();
        await _db.delete(_db.savedVerses).go();
        await _db.delete(_db.friendships).go();
        await _db.delete(_db.users).go();
      });

      // 3. Clear all cached settings/tokens
      await _prefs.clear();
      
    } on DioException catch (e) {
      // Handle network-specific errors
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Server unreachable. Please check your internet to delete your account.");
      }
      rethrow;
    } catch (e) {
      Debugger.log("UserRepository: Local wipe failed: $e");
      throw Exception('Failed to delete data: $e');
    }
  }
}

// --- Provider ---
final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  final prefs = await SharedPreferences.getInstance();
  final database = ref.watch(db.databaseProvider); 
  
  return UserRepository(dio, prefs, database);
});