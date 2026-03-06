import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/utils/network_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/utils/debugger.dart';
import '../../providers/core/dio_provider.dart';

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

      final response = await _dio.get('/user', options: options);
      final user = AppUser.fromJson(response.data as Map<String, dynamic>);
      
      await _prefs.setString(_kCachedUserKey, json.encode(response.data));

      await _db.into(_db.users).insert(
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
      Debugger.log("UserRepository: Network fetch failed. $e");

      // Check for specific network vs server errors
      final isOffline = e.type == DioExceptionType.connectionTimeout || 
                        e.type == DioExceptionType.receiveTimeout ||
                        e.error is SocketException;
      
      final isServerDown = e.response?.statusCode != null && e.response!.statusCode! >= 500;

      // Offline Fallback: Check local sources
      final localUser = await getLocalUser();
      if (localUser != null) {
        return localUser;
      }

      // If we have no local user and the fetch failed, throw the specific UI exception
      if (isServerDown) throw ServerDownException();
      if (isOffline) throw OfflineException();
      
      throw Exception("Connection required for initial login.");
    }
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
        registeredAt: dbUser.updatedAt
      );
    }

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
  final dio = await ref.watch(dioProvider.future);
  
  final prefs = await SharedPreferences.getInstance();
  final database = ref.watch(db.databaseProvider); 
  
  return UserRepository(dio, prefs, database);
});